# class TreesWorker
#   include Sidekiq::Worker
#   # sidekiq_options retry: false
#   include Sidekiq::Status::Worker
#
#   include TreesHelper
#
#   def perform(tree_id)
#     tree = Tree.find_by_id(tree_id)
#
#     logger.info "Extracting tree ##{tree_id}!"
#     puts "Extracting tree ##{tree_id}!"
#
#     at 10, "Resolve names in list"
#
#     resolved = JSON.parse(tree.raw_extraction.species) rescue []
#     if(resolved["resolvedNames"].length == 0)
#       tree.update_attributes( status: "unsuccessfully-extracted",
#                               bg_job: "-1",
#                               representation: nil )
#       return
#     end
#
#     at 20, "Resolved sucessfully"
#
#     at 25, "Prepare selected names"
#
#     chosen_species = JSON.parse(tree.chosen_species).select {|k,v| v == "1"}.map {|k,v| k }
#     resolved["resolvedNames"] = resolved["resolvedNames"].select do |r|
#       if r.key?("matched_results")
#         v = r["matched_results"][0]
#       else
#         v = r
#       end
#       chosen_species.include? v["matched_name"]
#     end
#
#     at 30, "Ready for passing names to tree extraction"
#
#     at 40, "Extract tree"
#     begin
#       extracted_response = Req.post( APP_CONFIG["sv_get_tree"]["url"],
#                                        resolved.to_json,
#                                        :content_type => :json,
#                                        :accept => :json )
#     rescue => e
#       puts e
#       logger.info "Call service error"
#     end
#
#     at 50, "Extracted tree successfully"
#
#     at 60, "Save extracted tree"
#
#     if !extracted_response
#       tree.update_attributes( status: "unsuccessfully-extracted",
#                               representation: nil )
#     elsif JSON.parse(extracted_response)["message"] == "Success"
#       extracted_response = extracted_response.to_s.gsub('\'', '')
#       tree.update_attributes( status: "unsuccessfully-scaled",
#                               representation: extracted_response )
#     else
#       extracted_response = extracted_response.to_s.gsub('\'', '')
#       tree.update_attributes( status: "unsuccessfully-extracted",
#                               representation: extracted_response )
#     end
#
#     at 70, "Scale tree"
#     begin
#       scaled_response = Req.post( APP_CONFIG["sv_datelife_tree"]["url"],
#                                   {"newick": sanitize_newick(tree), method: "median"}.to_json,
#                                   :content_type => :json,
#                                   :accept => :json )
#     rescue => e
#       puts e
#       logger.info "Call service error"
#     end
#     at 80, "Scaled tree successfully"
#
#     at 90, "Save scaled tree"
#     begin
#       if !scaled_response
#         tree.update_attributes( status: "unsuccessfully-scaled",
#                                 bg_job: "-1",
#                                 scaled_representation: nil )
#       elsif JSON.parse(scaled_response)["message"] == "Success"
#         scaled_response = scaled_response.to_s.gsub('\'', '')
#         tree.update_attributes( status: "completed",
#                                 bg_job: "-1",
#                                 scaled_representation: scaled_response )
#       else
#         scaled_response = scaled_response.to_s.gsub('\'', '')
#         tree.update_attributes( status: "unsuccessfully-scaled",
#                                 bg_job: "-1",
#                                 scaled_representation: scaled_response )
#       end
#     rescue => e
#       puts e
#     end
#
#     at 100, "Done"
#
#   end
# end