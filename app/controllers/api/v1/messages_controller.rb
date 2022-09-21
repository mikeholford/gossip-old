class Api::V1::MessagesController < Api::V1::BaseController
  
  after_action :add_request_headers

  def create
    @membership = Membership.find_by(room_id: params[:room_id], user_id: params[:user_id])
    if @membership.present?
      @message = Message.new(message_params)
      @message.source = :api
      if @message.save
        @message.send_webhook('message.created')
        SendMessageJob.perform_later(@message, 'api')
        render :show, status: :ok
      else
        render_error(@message)
      end
    else
      render_error(@message)
      # render json: {error: "User is not a member" }
    end
  end

  private 

  def message_params
    params.permit(:user_id, :room_id, :body)
  end

end
