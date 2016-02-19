class RawExtractionsController < ApplicationController
  before_action :authenticate_user!
  
  def new_from_file_and_web
    @con_link = ConLink.new
    @con_file = ConFile.new
  end
  
  def new_from_pre_built_examples
  end
  
end
