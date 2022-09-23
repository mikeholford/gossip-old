class RoomsController < ApplicationController
  before_action :authenticate_auth_link, only: %i[ show ]
  before_action :authenticate_user!
  before_action :set_account, only: %i[ index ]
  before_action :set_room, only: %i[ show edit update destroy ]
  before_action :authenticate_membership, only: [:show]


  # GET /rooms or /rooms.json
  def index
    @rooms = @account.rooms
  end

  # GET /rooms/1 or /rooms/1.json
  def show
    
    @membership = @room.membership_for(current_user.id)

    # @pagy, @messages = pagy(@room.messages.order(created_at: :desc), items: 20)

    
    if params[:jsload]
      
      @pagy, @messages = pagy(@room.messages.order(created_at: :desc), page: params[:page])

      html = @messages.map { |m| [render_to_string(partial: "messages/message", locals: { message: m, primary: (m.user == current_user), ref: m.id, status: "delivered", with_class: "" } )] }

      render json: { html: html, pagination: (view_context.pagy_nav(@pagy) if @pagy.present? ) }
    end

  end

  # GET /rooms/new
  def new
    @room = Room.new
  end

  # GET /rooms/1/edit
  def edit
  end

  # POST /rooms or /rooms.json
  def create
    @room = Room.new(room_params)

    respond_to do |format|
      if @room.save
        format.html { redirect_to @room, notice: "Room was successfully created." }
        format.json { render :show, status: :created, location: @room }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rooms/1 or /rooms/1.json
  def update
    respond_to do |format|
      if @room.update(room_params)
        format.html { redirect_to @room, notice: "Room was successfully updated." }
        format.json { render :show, status: :ok, location: @room }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rooms/1 or /rooms/1.json
  def destroy
    @room.destroy
    respond_to do |format|
      format.html { redirect_to rooms_url, notice: "Room was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

    def authenticate_auth_link
      if params[:auth].present?
        begin
          jwt_payload = JWT.decode(params[:auth], Rails.application.secrets.secret_key_base).first
          user = User.find_by(id: jwt_payload['id'])
          sign_in(:user, user) if user.present?
        rescue JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError
          return false
        end
      end
    end
    
    def authenticate_membership
      redirect_to root_url, alert: "Access Denied" unless current_user.is_member?(@room)
    end

    def set_account
      @account = Account.friendly.find(params[:account_id])
    end

    def set_room
      @room = Room.find(params[:id])
    end

    def room_params
      params.require(:room).permit(:name)
    end
end
