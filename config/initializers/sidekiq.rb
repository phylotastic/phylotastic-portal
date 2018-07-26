require 'sidekiq'
require 'sidekiq-status'

Sidekiq.configure_client do |config|
  config.client_middleware do |chain|
    # accepts :expiration (optional)
    chain.add Sidekiq::Status::ClientMiddleware, expiration: 30.minutes # default
  end
  if Rails.env == "production"
    config.redis = { url: 'redis://localhost:6379/0', namespace: "sidekiq_portal_#{Rails.env}" }
  elsif Rails.env == "development"
    config.redis = { url: 'redis://localhost:6379/1', namespace: "sidekiq_portal_#{Rails.env}" }
  end
end

Sidekiq.configure_server do |config|
  config.server_middleware do |chain|
    # accepts :expiration (optional)
    chain.add Sidekiq::Status::ServerMiddleware, expiration: 30.minutes # default
  end
  config.client_middleware do |chain|
    # accepts :expiration (optional)
    chain.add Sidekiq::Status::ClientMiddleware, expiration: 30.minutes # default
  end
  if Rails.env == "production"
    config.redis = { url: 'redis://localhost:6379/0', namespace: "sidekiq_portal_#{Rails.env}" }
  elsif Rails.env == "development"
    config.redis = { url: 'redis://localhost:6379/1', namespace: "sidekiq_portal_#{Rails.env}" }
  end
end