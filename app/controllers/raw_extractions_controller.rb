class RawExtractionsController < ApplicationController
  before_action :authenticate_user!
  
  def new_from_file_and_web
    @con_link = ConLink.new
    @con_file = ConFile.new
  end
  
  def new_from_pre_built_examples
    @uploaded_list = UploadedList.new
  end
  
  def new_from_taxon
    @con_taxon = ConTaxon.new
    @selection_taxon = SelectionTaxon.new
    @subset_taxon = SubsetTaxon.new
  end
  
end
