require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  
  test "full title helper" do
  
    assert_equal  "Twistter",  full_title
    assert_equal  "Help | Twistter",  full_title("Help")
  
  end
end