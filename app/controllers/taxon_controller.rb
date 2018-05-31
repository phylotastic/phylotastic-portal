class TaxonController < ApplicationController
  include ListsHelper
  
  def show
    if params[:from_service].nil?
      @from_service = false
      @list = List.find(params[:list_id])
      @resolved_names = @list.species_names
    else
      @from_service = true
      @list = get_a_list_from_service(params[:id])
    end
    
    respond_to do |format|
      format.pdf do
        render pdf: "taxon_matching_report",
               template: "lists/taxon_matching_report.pdf.erb"
      end
      format.csv do
        render csv: "taxon_matching_report",
               template: "lists/taxon_matching_report.csv.erb"
      end
    end
  end
end
