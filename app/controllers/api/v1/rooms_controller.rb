class Api::V1::RoomsController < Api::V1::BaseController
  
  after_action :add_request_headers

  def create
    @room = Room.new(room_params)
    if @room.save
        render :show, status: :ok
    else
        render_error(@room.errors.full_messages)
    end
  end

  private 

  def room_params
    params.permit(:account_id, :name)
  end

end
