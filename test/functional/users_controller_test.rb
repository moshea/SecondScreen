require_relative '../test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = FactoryGirl.build(:user)
  end

  test "should create user" do
    assert_difference('User.count') do
      post :create, user: { imei: @user.imei }
    end

    assert_redirected_to user_path(assigns(:user))
  end
  
  test "should create user with all attributes saved" do
    post :create, user: {imei: @user.imei, device_id: @user.device_id,
                         os_version: @user.os_version, api_level: @user.api_level, 
                         make: @user.make, model: @user.model }
                             
    new_user = User.find(assigns(:user).id)
    assert new_user.imei == @user.imei
    assert new_user.device_id == @user.device_id
    assert new_user.os_version == @user.os_version
    assert new_user.api_level == @user.api_level 
    assert new_user.make == @user.make
    assert new_user.model == @user.model
                    
    assert_redirected_to user_path(assigns(:user))                         
  end

end
