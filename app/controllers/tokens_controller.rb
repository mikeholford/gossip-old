class TokensController < ApplicationController

  before_action :set_account

  def create

    # notice_message = @account.api_token ? 'Token Regenerated' : 'New Token Generated'
    # @account.regenerate_api_token

    # redirect_to settings_account_path(@account, :anchor => 'developer'), notice: notice_message
  end

  def set_account
    @account = Account.friendly.find(params[:account_id])
  end
end
