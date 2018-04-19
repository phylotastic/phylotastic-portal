require 'test_helper'

class LinkTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
    @link = @user.links.build(url: "https://en.wikipedia.org/wiki/Common_ling")
  end
  
  test "should save article with validated url" do
    link = links(:fish_link)
    assert @link.save, "Did not save the correct link"
  end

  test "owner of link should be user 1" do
    assert @link.user.id == @user.id, "Wrong owner"
  end
  
  test "should not save link without url" do
    link = Link.new
    assert_not link.save, "Saved the link without a url"
  end
  
  test "should not save link with malformed url" do
    link = links(:malformed_link)
    assert_not link.save, "Saved the link with a malformed url"
  end
  
end
