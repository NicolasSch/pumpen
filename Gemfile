source 'https://rubygems.org'
ruby '2.4.1'

gem 'rails', '~> 5.1.3'
gem 'mysql2'
gem 'puma', '~> 3.0'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'rails-i18n', '~> 5.0.0' # For 5.0.x
gem 'toastr-rails'
gem 'jbuilder', '~> 2.5'
gem 'jquery-rails'
gem 'autoprefixer-rails'
gem 'tether-rails'
gem 'bootstrap-datepicker-rails'
gem 'simple_form'
gem 'devise'
gem 'cancancan'
gem 'wicked_pdf'
gem 'wkhtmltopdf-binary'
gem "font-awesome-rails"
gem 'sidekiq'              # background worker framework
gem 'foreman'              # process runner
gem 'smart_listing', git: "git://github.com/nicolassch/smart_listing.git", branch: 'master' # has error after rails update 5.1.1 uses deprecated method any on params object
gem 'devise-i18n'
gem 'bootstrap-select-rails'
gem "sentry-raven"
gem 'nokogiri'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem 'rspec-rails', '~> 3.5'
  gem 'factory_girl_rails'
  gem 'faker'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'mailcatcher'
end

group :test do
  gem 'database_cleaner'
  gem 'rails-controller-testing'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
