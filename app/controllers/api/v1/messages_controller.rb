class Api::V1::MessagesController < Api::V1::BaseController
  
  after_action :add_request_headers
  before_action :validate_user, only: [:create, :action]
  before_action :validate_room, only: [:create, :action]
  before_action :validate_membership, only: [:create, :action]
  before_action :set_message_params, only: [:create]

  def create
    @message = Message.new(message_params)
    @message.source = :api
    if @message.save
      SendMessageJob.perform_later(@message, 'api')
      render :show, status: :ok
    else
      render_error(@message.errors.full_messages)
    end
  end

  def action
    whitelist = ['typing_on', 'typing_off']
    if whitelist.include?(params[:reference])
      send("action_#{params[:reference]}")
    else
      render_error(["The action '#{params[:reference]}' is not supported"])
    end
  end

  def action_typing_on
    username = User.find(params[:user_id]).username # TODO: get username from view
    ActionCable.server.broadcast("room_channel_#{params[:room_id]}", {user_id: params[:user_id], username: username, category: 'typing', typing: true})
    render json: {success: true}
  end

  def action_typing_off
    username = User.find(params[:user_id]).username # TODO: get username from view
    ActionCable.server.broadcast("room_channel_#{params[:room_id]}", {user_id: params[:user_id], username: username, category: 'typing', typing: false})
    render json: {success: true}
  end

  private 

  def validate_user
    @user = @account.users.find_by(id: params[:user_id])
    render_error(["User does not exist"]) unless @user
  end

  def validate_room
    @room = @account.rooms.find_by(id: params[:room_id])
    render_error(["Room does not exist"]) unless @room
  end

  def validate_membership
    @membership = @room.memberships.api.find_by(user_id: @user.id)
    render_error(["User is not a member of this room"]) unless @membership
  end

  def set_message_params
    params[:body] = params[:message][:text]
    params[:attachment] = params[:message][:attachment]
  end

  def message_params
    params.permit(:user_id, :room_id, :body, :attachment)
  end

end
