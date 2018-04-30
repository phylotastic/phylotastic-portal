require 'test_helper'

class DocumentTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
    @document = @user.documents.build(file: File.new("test/fixtures/t.txt"), 
                                      method: "NetiNeti")
  end
  
  test "should save document" do
    assert @document.save, "Did not save the correct link"
  end

  test "owner of link should be user 1" do
    assert @document.user.id == @user.id, "Wrong owner"
  end
  
  test "should not save document without file" do
    document = Document.new
    assert_not document.save, "Saved the link without a url"
  end
    
  test "should save associated list" do
    @document.save
    @list = @document.build_list( name: lists(:one).name, 
                                  description: lists(:one).description, 
                                  species_names: "Common ling" )
    assert @list.save, "Not save associated list"
    assert @document.list.name = @list.name, "Can not call list"
    assert @list.resource.file = @document.file, "Can not call associated resource"
  end
end
