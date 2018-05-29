class TaxonController < ApplicationController
  def show
    @list = List.find(params[:list_id])
    @resolved_names = @list.species_names
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
