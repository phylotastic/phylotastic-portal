require 'test_helper'

class OnplTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
    @onpl = @user.onpls.build(file: File.new("test/fixtures/t.txt"))
  end
  
  test "should save onpl" do
    assert @onpl.save, "Did not save"
  end

  test "owner of link should be user 1" do
    assert @onpl.user.id == @user.id, "Wrong owner"
  end
  
  test "should not save onpl without file" do
    onpl = Onpl.new
    assert_not onpl.save, "Saved the link without a file"
  end
    
  test "should save associated list" do
    @onpl.save
    @list = @onpl.build_list( name: lists(:one).name, 
                                  description: lists(:one).description, 
                                  species_names: "Common ling" )
    assert @list.save, "Not save associated list"
    assert @onpl.list.name = @list.name, "Can not call list"
    assert @list.resource.file = @onpl.file, "Can not call associated resource"
  end
end
