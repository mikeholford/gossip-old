class RoomChannel < ApplicationCable::Channel
  def subscribed
    stream_from "room_channel_#{params[:room_id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    ActionCable.server.broadcast("room_channel_#{params[:room_id]}", {user_id: current_user.id, username: current_user.username, category: 'typing', typing: false})
  end
end
