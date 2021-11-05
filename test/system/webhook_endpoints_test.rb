require "application_system_test_case"

class WebhookEndpointsTest < ApplicationSystemTestCase
  setup do
    @webhook_endpoint = webhook_endpoints(:one)
  end

  test "visiting the index" do
    visit webhook_endpoints_url
    assert_selector "h1", text: "Webhook Endpoints"
  end

  test "creating a Webhook endpoint" do
    visit webhook_endpoints_url
    click_on "New Webhook Endpoint"

    fill_in "Account", with: @webhook_endpoint.account_id
    fill_in "Events", with: @webhook_endpoint.events
    fill_in "Logs", with: @webhook_endpoint.logs
    fill_in "Secret", with: @webhook_endpoint.secret
    fill_in "Status", with: @webhook_endpoint.status
    fill_in "Url", with: @webhook_endpoint.url
    click_on "Create Webhook endpoint"

    assert_text "Webhook endpoint was successfully created"
    click_on "Back"
  end

  test "updating a Webhook endpoint" do
    visit webhook_endpoints_url
    click_on "Edit", match: :first

    fill_in "Account", with: @webhook_endpoint.account_id
    fill_in "Events", with: @webhook_endpoint.events
    fill_in "Logs", with: @webhook_endpoint.logs
    fill_in "Secret", with: @webhook_endpoint.secret
    fill_in "Status", with: @webhook_endpoint.status
    fill_in "Url", with: @webhook_endpoint.url
    click_on "Update Webhook endpoint"

    assert_text "Webhook endpoint was successfully updated"
    click_on "Back"
  end

  test "destroying a Webhook endpoint" do
    visit webhook_endpoints_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Webhook endpoint was successfully destroyed"
  end
end
