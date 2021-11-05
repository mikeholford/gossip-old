require "test_helper"

class WebhookEndpointsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @webhook_endpoint = webhook_endpoints(:one)
  end

  test "should get index" do
    get webhook_endpoints_url
    assert_response :success
  end

  test "should get new" do
    get new_webhook_endpoint_url
    assert_response :success
  end

  test "should create webhook_endpoint" do
    assert_difference('WebhookEndpoint.count') do
      post webhook_endpoints_url, params: { webhook_endpoint: { account_id: @webhook_endpoint.account_id, events: @webhook_endpoint.events, logs: @webhook_endpoint.logs, secret: @webhook_endpoint.secret, status: @webhook_endpoint.status, url: @webhook_endpoint.url } }
    end

    assert_redirected_to webhook_endpoint_url(WebhookEndpoint.last)
  end

  test "should show webhook_endpoint" do
    get webhook_endpoint_url(@webhook_endpoint)
    assert_response :success
  end

  test "should get edit" do
    get edit_webhook_endpoint_url(@webhook_endpoint)
    assert_response :success
  end

  test "should update webhook_endpoint" do
    patch webhook_endpoint_url(@webhook_endpoint), params: { webhook_endpoint: { account_id: @webhook_endpoint.account_id, events: @webhook_endpoint.events, logs: @webhook_endpoint.logs, secret: @webhook_endpoint.secret, status: @webhook_endpoint.status, url: @webhook_endpoint.url } }
    assert_redirected_to webhook_endpoint_url(@webhook_endpoint)
  end

  test "should destroy webhook_endpoint" do
    assert_difference('WebhookEndpoint.count', -1) do
      delete webhook_endpoint_url(@webhook_endpoint)
    end

    assert_redirected_to webhook_endpoints_url
  end
end
