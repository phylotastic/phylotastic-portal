require 'test_helper'

class ListsControllerTest < ActionDispatch::IntegrationTest

  test "successful edit" do
    post "/links",
      params: { link: { url: links(:fish_link).url }, 
                name: lists(:one).name, 
                description: "A list of fish species" }
    
    @list = Link.first.list      
    get edit_list_path(@list.id)
    assert_select "title", "Edit list | Phylotastic Portal"
    
    name = "Foo Bar"
    description = "Serum a la bale humle"
    patch list_path(@list), params: { list: { name:  name,
                                              description: description } }
    assert_not flash.empty?
    assert_redirected_to lists_path
    @list.reload
    assert_equal name, @list.name
    assert_equal description, @list.description
  end

  test "should get index" do
    get lists_path
    assert_response :success
    assert_select "title", "Home | Phylotastic Portal"
  end

end
