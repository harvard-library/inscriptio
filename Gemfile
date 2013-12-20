source 'http://rubygems.org'

gem 'rails',        '3.2.14'
gem 'pg',           '~> 0.17.0'
gem 'formtastic',   '~> 2.2.1'
gem 'acts_as_list', '~> 0.3.0'
gem 'jquery-rails', '~> 3.0.4'
gem 'jquery-ui-rails', '~> 4.0.5'
gem 'devise',       '~> 3.1.1'
gem 'carrierwave',  '~> 0.9.0'
gem 'mini_magick',  '~> 3.6.0'
gem 'fastercsv',    '~> 1.5.5'
gem 'breadcrumbs',  '~> 0.1.6'
gem 'rake',         '~> 10.1.0'
gem 'rubyzip',      '~> 1.0.0'
gem 'zip-zip'       # rubyzip 1.x.x breaks gems depending on 0.9 interface
gem 'dotenv-rails', '~> 0.9.0'
gem 'paranoia',     '~> 1.0' # Soft delete gem providing "acts_as_paranoid" for use in models
group :assets do
  gem 'sass-rails',   '~> 3.2.6'
  gem 'coffee-rails', '~> 3.2.2'
  gem 'uglifier',     '~> 2.2.1'
end

group :test do
  gem 'cucumber-rails',  '~> 1.4.0', :require => false
end

group :development do
  gem 'capistrano',   '~> 3.0.1'
  gem 'capistrano-rails', '~> 1.0.0'
  gem 'capistrano-rvm', '~> 0.0.3'
  gem 'capistrano-bundler', '~> 1.0.0'
  gem 'better_errors'
  gem 'binding_of_caller'
end

group :development,:test do
  gem 'pry'
  gem 'capybara', '~> 2.1'
  gem 'poltergeist'
  gem 'database_cleaner', '0.6.6'
  gem 'shoulda-matchers', '2.4.0'
  gem 'sqlite3'
  gem 'selenium-client', '1.2.18'
  gem 'selenium-webdriver', '0.1.4'
  gem 'rspec-rails', '~> 2.0'
  gem 'launchy'
  gem 'factory_girl_rails', '~> 4.0'
end
