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
  
  test "should save associated list" do
    @link.save
    @list = @link.build_list( name: lists(:one).name, 
                              description: lists(:one).description, 
                              species_names: "Common ling" )
    assert @list.save, "Not save associated list"
    assert @link.list.name = @list.name, "Can not call list"
    assert @list.resource.url = @link.url, "Can not call associated resource"
  end
  
end
