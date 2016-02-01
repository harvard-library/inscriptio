source 'http://rubygems.org'

gem 'rails',        '4.2.5'
gem 'pg',           '~> 0.18.4'
gem 'formtastic',   '~> 3.1.3'
gem 'acts_as_list', '~> 0.7.2'
gem 'jquery-rails', '~> 4.0.5'
gem 'jquery-ui-rails', '~> 5.0.5'
gem 'devise',       '~> 3.5.5'
gem 'cancancan',    '~> 1.13.1'
gem 'carrierwave',  '~> 0.9.0'
gem 'mini_magick',  '~> 3.6.0'
gem 'breadcrumbs',  '~> 0.1.6'
gem 'rake',         '~> 10.2.0'
gem 'rubyzip',      '~> 1.0.0'
gem 'zip-zip'       # rubyzip 1.x.x breaks gems depending on rubyzip 0.9 interface
gem 'dotenv-rails', '~> 0.9.0'

gem 'paranoia',     '~> 2.1.5'  # upgrade to rails 4
#gem 'foreigner',    '~> 1.6.1' # Gem providing foreign key support for ActiveRecord
# removing assets group per http://railscasts.com/episodes/415-upgrading-to-rails-4
gem 'sass-rails',   '~> 5.0.4'
gem 'coffee-rails', '~> 4.1.1'
gem 'uglifier',     '~> 2.7.2'

# *** ADDING THESE for transition
#gem 'protected_attributes'
gem 'rails-observers'
gem 'actionpack-page_caching'
gem 'actionpack-action_caching'
# ****



group :test do
  gem 'minitest'
  gem 'capybara', '~> 2.1'
  gem 'poltergeist'
  gem 'database_cleaner', '~> 1.5.1'
  gem 'shoulda-matchers', '2.4.0'
  gem 'rspec-rails', '~> 2.0'
  gem 'factory_girl_rails', '~> 4.0'
  gem 'cucumber-rails',  '~> 1.4.0', :require => false
end

group :development do
  gem 'capistrano',        '~> 3.1.0'
  gem 'capistrano-rails',  '~> 1.0.0'
  gem 'capistrano-rvm',    '~> 0.1.1'
  gem 'capistrano-bundler','~> 1.1.2'
  gem 'better_errors'
  gem 'binding_of_caller'
end

group :development,:test do
  gem 'pry'
  gem 'sqlite3'
  gem 'launchy'
end
