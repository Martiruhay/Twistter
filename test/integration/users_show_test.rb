require 'test_helper'

class UsersShowTest < ActionDispatch::IntegrationTest
  
  def setup
    @unactivated = users(:unactivated)
    @user = users(:mitra)
  end
  
  test "show activated user" do
    get user_path(@user)
    assert_template 'users/show'
  end
  
  test "show unactivated user" do
    get user_path(@unactivated)
    assert_redirected_to(root_url)
  end
  
end
