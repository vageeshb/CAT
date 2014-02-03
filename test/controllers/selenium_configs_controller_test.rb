require 'test_helper'

class SeleniumConfigsControllerTest < ActionController::TestCase
  setup do
    @selenium_config = selenium_configs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:selenium_configs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create selenium_config" do
    assert_difference('SeleniumConfig.count') do
      post :create, selenium_config: { browser: @selenium_config.browser, url: @selenium_config.url, user_id: @selenium_config.user_id }
    end

    assert_redirected_to selenium_config_path(assigns(:selenium_config))
  end

  test "should show selenium_config" do
    get :show, id: @selenium_config
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @selenium_config
    assert_response :success
  end

  test "should update selenium_config" do
    patch :update, id: @selenium_config, selenium_config: { browser: @selenium_config.browser, url: @selenium_config.url, user_id: @selenium_config.user_id }
    assert_redirected_to selenium_config_path(assigns(:selenium_config))
  end

  test "should destroy selenium_config" do
    assert_difference('SeleniumConfig.count', -1) do
      delete :destroy, id: @selenium_config
    end

    assert_redirected_to selenium_configs_path
  end
end
