class Api::V1::BaseController < ActionController::API
  include HasRateLimits
  include Renderable

  include ActionController::Helpers

  before_action :authenticate_api_request
  before_action :track_api_usage

  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  def path_not_found
    render_not_found
  end

  private

  def authenticate_api_request
    token = request.headers['Authorization']
    @account = Account.authenticate_token(token)
    render_unauthenticated unless token && @account
  end

  def track_api_usage
    # To clear the redis cache when testing, use the following command in your terminal
    # redis-cli FLUSHALL
    acc_key = "count_#{@account.id}"
    blocked_acc_key = "locked_#{@account.id}"

    render_too_many_reqs if $redis.get(blocked_acc_key)

    if $redis.get(acc_key)
      @number_of_requests = $redis.incr(acc_key)

      if @number_of_requests >= HasRateLimits::REQUESTS_ALLOWED
        $redis.set(blocked_acc_key,1)
        $redis.expire(blocked_acc_key, HasRateLimits::COOLDOWN)
      end
    else
      $redis.set(acc_key,1)
      $redis.expire(acc_key, HasRateLimits::WINDOW)
      @number_of_requests = 1
    end
  end

  def add_request_headers
    response.set_header("X-Rate-Limit", "#{HasRateLimits::REQUESTS_ALLOWED}")
    response.set_header("X-Rate-Limit-Remaining", "#{HasRateLimits::REQUESTS_ALLOWED - @number_of_requests}")
    response.set_header("X-Rate-Limit-Period", "#{HasRateLimits::WINDOW} seconds")
  end

end
