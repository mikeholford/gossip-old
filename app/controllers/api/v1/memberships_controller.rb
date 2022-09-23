class Api::V1::MembershipsController < Api::V1::BaseController
  
  after_action :add_request_headers

  def create
    @membership = Membership.new(membership_params)
    if @membership.save
        render :show, status: :ok
    else
        render_error(@membership.errors.full_messages)
    end
  end

  private 

  def membership_params
    params.permit(:user_id, :room_id)
  end

end
