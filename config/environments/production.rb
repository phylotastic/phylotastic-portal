Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Code is not reloaded between requests.
  config.cache_classes = true

  # Eager load code on boot. This eager loads most of Rails and
  # your application in memory, allowing both threaded web servers
  # and those relying on copy on write to perform better.
  # Rake tasks automatically ignore this option for performance.
  config.eager_load = true

  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Attempt to read encrypted secrets from `config/secrets.yml.enc`.
  # Requires an encryption key in `ENV["RAILS_MASTER_KEY"]` or
  # `config/secrets.yml.key`.
  config.read_encrypted_secrets = true

  # Disable serving static files from the `/public` folder by default since
  # Apache or NGINX already handles this.
  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?

  # Compress JavaScripts and CSS.
  # config.assets.js_compressor = Uglifier.new(harmony: true)
  # config.assets.css_compressor = :sass

  # Do not fallback to assets pipeline if a precompiled asset is missed.
  config.assets.compile = false

  # `config.assets.precompile` and `config.assets.version` have moved to config/initializers/assets.rb

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  # config.action_controller.asset_host = 'http://assets.example.com'

  # Specifies the header that your server uses for sending files.
  # config.action_dispatch.x_sendfile_header = 'X-Sendfile' # for Apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for NGINX

  # Mount Action Cable outside main process or domain
  # config.action_cable.mount_path = nil
  # config.action_cable.url = 'wss://example.com/cable'
  # config.action_cable.allowed_request_origins = [ 'http://example.com', /http:\/\/example.*/ ]

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # Use the lowest log level to ensure availability of diagnostic information
  # when problems arise.
  config.log_level = :debug

  # Prepend all log lines with the following tags.
  config.log_tags = [ :request_id ]

  # Use a different cache store in production.
  # config.cache_store = :mem_cache_store

  # Use a real queuing backend for Active Job (and separate queues per environment)
  # config.active_job.queue_adapter     = :resque
  # config.active_job.queue_name_prefix = "phylotastic-portal_#{Rails.env}"
  config.action_mailer.perform_caching = false

  # Ignore bad email addresses and do not raise email delivery errors.
  # Set this to true and configure the email server for immediate delivery to raise delivery errors.
  # config.action_mailer.raise_delivery_errors = false

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation cannot be found).
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners.
  config.active_support.deprecation = :notify

  # Use default logging formatter so that PID and timestamp are not suppressed.
  config.log_formatter = ::Logger::Formatter.new

  # Use a different logger for distributed setups.
  # require 'syslog/logger'
  # config.logger = ActiveSupport::TaggedLogging.new(Syslog::Logger.new 'app-name')

  if ENV["RAILS_LOG_TO_STDOUT"].present?
    logger           = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger    = ActiveSupport::TaggedLogging.new(logger)
  end

  config.action_cable.url = "ws://phylo.cs.nmsu.edu:3000/cable"
  

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false
  
  Rails.application.configure do
    config.x.public_lists_sv.url = "http://phylo.cs.nmsu.edu:5007/phylotastic_ws/sls/get_list"
    config.x.wct = "http://104.197.8.189/WCT/"
    config.x.ete_js = "http://phylo.cs.nmsu.edu:8080/ete.js"
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
    config.x.sv_Add_new_list = "http://phylo.cs.nmsu.edu:5007/phylotastic_ws/sls/insert_list"
    config.x.sv_OToL_scale_tree = "http://phylo.cs.nmsu.edu:5009/phylotastic_ws/sc/ot/scale"
    config.x.sv_Taxon_popular_species = "http://phylo.cs.nmsu.edu:5006/phylotastic_ws/ts/popular_species?taxon="
  end
end
