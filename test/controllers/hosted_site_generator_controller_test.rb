require 'test_helper'

class HostedSiteGeneratorControllerTest < ActionDispatch::IntegrationTest
  test "should get new_site" do
    get hosted_site_generator_new_site_url
    assert_response :success
  end

end
