Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # The test environment is used exclusively to run your application's
  # test suite. You never need to work with it otherwise. Remember that
  # your test database is "scratch space" for the test suite and is wiped
  # and recreated between test runs. Don't rely on the data there!
  config.cache_classes = true

  # Do not eager load code on boot. This avoids loading your whole application
  # just for the purpose of running a single test. If you are using a tool that
  # preloads Rails for running tests, you may have to set it to true.
  config.eager_load = false

  # Configure public file server for tests with Cache-Control for performance.
  config.public_file_server.enabled = true
  config.public_file_server.headers = {
    'Cache-Control' => "public, max-age=#{1.hour.seconds.to_i}"
  }

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Raise exceptions instead of rendering exception templates.
  config.action_dispatch.show_exceptions = false

  # Disable request forgery protection in test environment.
  config.action_controller.allow_forgery_protection = false
  config.action_mailer.perform_caching = false

  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  config.action_mailer.delivery_method = :test

  # Print deprecation notices to the stderr.
  config.active_support.deprecation = :stderr

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  Rails.application.configure do
    config.x.public_lists_sv.url = "http://phylo.cs.nmsu.edu:5005/phylotastic_ws/sls/get_list"
    config.x.wct = "http://104.197.8.189/WCT/"
    config.x.ete_js = "http://phylo.cs.nmsu.edu:8080/TreeViewer/demo/ete_dev2.js"
    config.x.ot_tree_uri = "https://tree.opentreeoflife.org/curator/study/view/"
    config.x.sv_GNRD_wrapper_URL = "http://phylo.cs.nmsu.edu:5004/phylotastic_ws/fn/names_url?url="
    config.x.sv_OToL_TNRS_wrapper = "http://phylo.cs.nmsu.edu:5004/phylotastic_ws/tnrs/ot/names"
    config.x.sv_OToL_TNRS_wrapper_get = "http://phylo.cs.nmsu.edu:5004/phylotastic_ws/tnrs/ot/resolve?names="
    config.x.sv_GNRD_wrapper_file = "http://phylo.cs.nmsu.edu:5004/phylotastic_ws/fn/names_file"
    config.x.sv_GNRD_wrapper_text = "http://phylo.cs.nmsu.edu:5004/phylotastic_ws/fn/names_text?text="
    config.x.sv_Taxon_country_species = "http://phylo.cs.nmsu.edu:5004/phylotastic_ws/ts/country_species?taxon="
    config.x.sv_Taxon_genome_species = "http://phylo.cs.nmsu.edu:5004/phylotastic_ws/ts/ncbi/genome_species?taxon="
    config.x.sv_Taxon_all_species = "http://phylo.cs.nmsu.edu:5004/phylotastic_ws/ts/all_species?taxon="
    config.x.sv_OToL_wrapper_Tree = "http://phylo.cs.nmsu.edu:5004/phylotastic_ws/gt/ot/tree"
    config.x.sv_Datelife_scale_tree = "http://phylo.cs.nmsu.edu:5009/phylotastic_ws/sc/scale"
  end
end
