Rails.application.configure do
  config.cache_classes = false
  config.eager_load = false
  config.consider_all_requests_local = true

  if Rails.root.join('tmp/caching-dev.txt').exist?
    config.action_controller.perform_caching = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => 'public, max-age=172800'
    }
  else
    config.action_controller.perform_caching = false
    config.cache_store = :null_store
  end

  config.action_mailer.default_url_options = { host: 'localhost:3000' }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = { address: "localhost", port: 1025 }
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.preview_path = "#{Rails.root}/spec/mailers/previews"
  config.action_mailer.default_url_options = { :host => "localhost:3000" }
  config.active_support.deprecation = :log
  config.active_record.migration_error = :page_load
  config.assets.debug = true
  config.assets.quiet = true
  config.x.redis_url = 'redis://localhost:6800/1'

  # enable it to see error pages in development
  # config.consider_all_requests_local = false
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker
end
