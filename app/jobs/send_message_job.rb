class SendMessageJob < ApplicationJob
  queue_as :default
  before_perform :wardenize

  def perform(message)

    primary = @job_renderer.render(
      partial: "messages/message", 
      locals: {message: message, primary: true}
    )

    default = @job_renderer.render(
      partial: "messages/message", 
      locals: {message: message, primary: false}
    )

    ActionCable.server.broadcast("room_channel_#{message.room_id}", {primary: primary, default: default, message: message})
    
  end

  private
  
  # Specific to devise and warden issues when trying to call current_user in render partial on bg job
  # https://gist.github.com/hopsoft/9c84c354e354c16898a44625df094347
  def wardenize
    @job_renderer = ::ApplicationController.renderer.new
    renderer_env = @job_renderer.instance_eval { @env }
    warden = ::Warden::Proxy.new(renderer_env, ::Warden::Manager.new(Rails.application))
    renderer_env["warden"] = warden
  end
end
