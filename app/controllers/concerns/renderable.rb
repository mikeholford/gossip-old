module Renderable
  extend ActiveSupport::Concern
  include HasRateLimits

  def render_unauthenticated
    render json: { error: "Access denied due to invalid credentials" }, status: :unauthorized
  end

  def render_too_many_reqs
    render json: { error: "Too many requests fired within time limit. Please wait #{(HasRateLimits::COOLDOWN/60).ceil} minute(s)" }, status: :too_many_requests
  end

  def render_not_found(exception)
    render json: { error: exception.message }, status: :not_found
  end

  def render_error(element)
    render json: { errors: element.errors.messages.flatten },
      status: :unprocessable_entity
  end

  def render_required_missing(element)
    render json: { error: "Missing parameter required. Please provide #{element} in your request"}, status: :bad_request
  end

  def render_not_found
    render json: { error: "Routing error, endpoint not found"}, status: :not_found
  end
end
