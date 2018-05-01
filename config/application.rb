# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module Pumpen
  class Application < Rails::Application
    I18n.available_locales = %i[de en]
    I18n.default_locale = :de
    config.time_zone = 'Europe/Berlin'
    config.active_job.queue_adapter = :sidekiq
    config.filter_parameters << :password
    config.active_record.sqlite3.represent_boolean_as_integer = true
  end
end
