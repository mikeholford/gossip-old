class TokensController < ApplicationController

  before_action :set_organisation

  def create

    notice_message = @organisation.api_token ? 'Token Regenerated' : 'New Token Generated'
    @organisation.regenerate_api_token

    redirect_to settings_organisation_path(@organisation, :anchor => 'developer'), notice: notice_message
  end

  def set_organisation
    @organisation = Organisation.friendly.find(params[:organisation_id])
  end
end
