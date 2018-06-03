require 'test_helper'

class DcaTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
    @dca = @user.dcas.build(file: File.new("test/fixtures/files/study1.zip"))
  end
  
  test "should save dca" do
    assert @dca.save, "Did not save"
  end

  test "owner of link should be user 1" do
    assert @dca.user.id == @user.id, "Wrong owner"
  end
  
  test "should not save dca without file" do
    dca = Dca.new
    assert_not dca.save, "Saved the link without a file"
  end
    
  test "should save associated list" do
    @dca.save
    @list = @dca.build_list( name: lists(:one).name, 
                             description: lists(:one).description, 
                             species_names: "Common ling" )
    assert @list.save, "Not save associated list"
    assert @dca.list.name = @list.name, "Can not call list"
    assert @list.resource.file = @dca.file, "Can not call associated resource"
  end
end
