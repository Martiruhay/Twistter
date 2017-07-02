require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:mitra)
  end
  
  test "micropost interface" do
    log_in_as(@user)
    get root_url
    assert_select 'div.pagination'
    assert_select 'input[type=file]'
    # Invalid submission
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: "" } }
    end
    assert_select 'div#error_explanation'
    # Valid sumbission
    content = "Integration test micropost content wo wo wo wo!"
    picture = fixture_file_upload('test/fixtures/rails.png', 'image/png')
    assert_difference 'Micropost.count', 1 do
      post microposts_path, params: { micropost: { content: content, picture: picture } }
    end
    assert Micropost.first.picture?
    assert_redirected_to root_url
    follow_redirect!
    assert_match content, response.body
    # Delete post
    assert_select 'a', text: "delete"
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end
    # Visit different user (no delete link)
    get user_path(users(:michael))
    assert_select 'a', text: "delete", count: 0
  end
  
  test "micropost sidebar count" do
    log_in_as(@user)
    get root_url
    assert_match "#{@user.microposts.count} microposts", response.body
    # User with zero microposts
    other_user = users(:mudo)
    log_in_as(other_user)
    get root_url
    assert_match "0 microposts", response.body
    other_user.microposts.create!(content: "A new micropost!")
    get root_url
    assert_match "1 micropost", response.body
  end
  
end
