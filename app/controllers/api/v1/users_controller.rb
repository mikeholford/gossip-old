class Api::V1::UsersController < Api::V1::BaseController
  
  after_action :add_request_headers

  def create
    @user = User.find_or_initialize_by(email: params[:email])
    if @user.new_record?
        @user.password = SecureRandom.hex(10)
        @user.username = params[:username]
        if @user.save
            render :show, status: :ok
        else
            render_error(@user)
        end
    else
        render :show, status: :ok
    end
  end

  def login
    @user = User.find(params[:id])
    render :login, status: :ok
  end

end