class WebhookEndpointsController < ApplicationController
  before_action :set_webhook_endpoint, only: %i[ show edit update destroy ]

  # GET /webhook_endpoints or /webhook_endpoints.json
  def index
    @webhook_endpoints = WebhookEndpoint.all
  end

  # GET /webhook_endpoints/1 or /webhook_endpoints/1.json
  def show
  end

  # GET /webhook_endpoints/new
  def new
    @webhook_endpoint = WebhookEndpoint.new
  end

  # GET /webhook_endpoints/1/edit
  def edit
  end

  # POST /webhook_endpoints or /webhook_endpoints.json
  def create
    @webhook_endpoint = WebhookEndpoint.new(webhook_endpoint_params)

    respond_to do |format|
      if @webhook_endpoint.save
        format.html { redirect_to @webhook_endpoint, notice: "Webhook endpoint was successfully created." }
        format.json { render :show, status: :created, location: @webhook_endpoint }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @webhook_endpoint.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /webhook_endpoints/1 or /webhook_endpoints/1.json
  def update
    respond_to do |format|
      if @webhook_endpoint.update(webhook_endpoint_params)
        format.html { redirect_to @webhook_endpoint, notice: "Webhook endpoint was successfully updated." }
        format.json { render :show, status: :ok, location: @webhook_endpoint }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @webhook_endpoint.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /webhook_endpoints/1 or /webhook_endpoints/1.json
  def destroy
    @webhook_endpoint.destroy
    respond_to do |format|
      format.html { redirect_to webhook_endpoints_url, notice: "Webhook endpoint was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_webhook_endpoint
      @webhook_endpoint = WebhookEndpoint.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def webhook_endpoint_params
      params.require(:webhook_endpoint).permit(:account_id, :url, :events, :status, :logs, :secret)
    end
end
