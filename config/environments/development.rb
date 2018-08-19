Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable/disable caching. By default caching is disabled.
  if Rails.root.join('tmp/caching-dev.txt').exist?
    config.action_controller.perform_caching = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => "public, max-age=#{2.days.seconds.to_i}"
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  config.action_mailer.perform_caching = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Suppress logger output for asset requests.
  config.assets.quiet = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker
  
  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
  
  config.action_cable.url = "ws://localhost:3001/cable"
  
  Paperclip.options[:command_path] = "/usr/local/bin/"
  
  Rails.application.configure do
    config.x.public_lists_sv.url = "http://phylo.cs.nmsu.edu:5005/phylotastic_ws/sls/get_list"
    config.x.wct = "http://104.197.8.189/WCT/"
    config.x.ete_js = "http://phylo.cs.nmsu.edu:8080/ete_dev2.js"
    config.x.ot_tree_uri = "https://tree.opentreeoflife.org/curator/study/view/"
    config.x.sv_GNRD_wrapper_URL = "http://phylo.cs.nmsu.edu:5004/phylotastic_ws/fn/names_url?url="
    config.x.sv_TaxonFinder_wrapper_URL = "http://phylo.cs.nmsu.edu:5004/phylotastic_ws/fn/tf/names_url?url="
    config.x.sv_OToL_TNRS_wrapper = "http://phylo.cs.nmsu.edu:5004/phylotastic_ws/tnrs/ot/names"
    config.x.sv_GNR_TNRS_wrapper = "http://phylo.cs.nmsu.edu:5004/phylotastic_ws/tnrs/gnr/names"
    config.x.sv_OToL_TNRS_wrapper_get = "http://phylo.cs.nmsu.edu:5004/phylotastic_ws/tnrs/ot/resolve?names="
    config.x.sv_GNRD_wrapper_file = "http://phylo.cs.nmsu.edu:5004/phylotastic_ws/fn/names_file"
    config.x.sv_GNRD_wrapper_text = "http://phylo.cs.nmsu.edu:5004/phylotastic_ws/fn/names_text?text="
    config.x.sv_TaxonFinder_wrapper_text = "http://phylo.cs.nmsu.edu:5004/phylotastic_ws/fn/tf/names_text?text="
    config.x.sv_Taxon_country_species = "http://phylo.cs.nmsu.edu:5004/phylotastic_ws/ts/country_species?taxon="
    config.x.sv_Taxon_genome_species = "http://phylo.cs.nmsu.edu:5004/phylotastic_ws/ts/ncbi/genome_species?taxon="
    config.x.sv_Taxon_all_species = "http://phylo.cs.nmsu.edu:5004/phylotastic_ws/ts/all_species?taxon="
    config.x.sv_OToL_wrapper_Tree = "http://phylo.cs.nmsu.edu:5004/phylotastic_ws/gt/ot/tree"
    config.x.sv_Phylomatic_wrapper_Tree = "http://phylo.cs.nmsu.edu:5004/phylotastic_ws/gt/pm/get_tree"
    config.x.sv_Datelife_scale_tree = "http://phylo.cs.nmsu.edu:5009/phylotastic_ws/sc/scale"
    config.x.sv_Add_new_list = "http://phylo.cs.nmsu.edu:5005/phylotastic_ws/sls/insert_list"
    config.x.sv_OToL_scale_tree = "http://phylo.cs.nmsu.edu:5009/phylotastic_ws/sc/ot/scale"
    config.x.sv_Taxon_popular_species = "http://phylo.cs.nmsu.edu:5006/phylotastic_ws/ts/popular_species?taxon="
  end
end
