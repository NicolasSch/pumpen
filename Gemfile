# frozen_string_literal: true

source 'https://rubygems.org'
ruby '2.5.1'

gem 'autoprefixer-rails'
gem 'bootstrap-datepicker-rails'
gem 'bootstrap-select-rails'
gem 'cancancan'
gem 'coffee-rails', '~> 4.2'
gem 'devise'
gem 'devise-i18n'
gem 'font-awesome-rails'
gem 'foreman' # process runner
gem 'jbuilder', '~> 2.5'
gem 'jquery-rails'
gem 'mysql2'
gem 'nokogiri'
gem 'puma', '~> 3.0'
gem 'rails', '~> 5.2.0'
gem 'rails-i18n', '~> 5.0.0' # For 5.0.x
gem 'sass-rails', '~> 5.0'
gem 'sentry-raven'
gem 'sidekiq' # background worker framework
gem 'simple_form'
gem 'smart_listing', git: 'git://github.com/nicolassch/smart_listing.git', branch: 'master' # has error after rails update 5.1.1 uses deprecated method any on params object
gem 'tether-rails'
gem 'toastr-rails'
gem 'uglifier', '>= 1.3.0'
gem 'wicked_pdf'
gem 'wkhtmltopdf-binary'
gem 'google_drive'
gem 'active_model_attributes'

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'rspec-rails', '~> 3.5'
end

group :development do
  gem 'listen', '~> 3.0.5'
  gem 'mailcatcher'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'database_cleaner'
  gem 'rails-controller-testing'
end
