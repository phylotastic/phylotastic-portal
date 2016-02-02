class RawExtractionsController < ApplicationController
  def new_from_file_and_web
    @con_link = ConLink.new
    @con_file = ConFile.new
  end
end
