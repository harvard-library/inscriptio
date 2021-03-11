source 'http://rubygems.org'

gem 'rails',        '5.2.4.5'
gem 'pg',           '~> 0.18.4'
gem 'formtastic',   '~> 4.0.0'
gem 'acts_as_list', '~> 0.7.2'
gem 'jquery-rails', '~> 4.4.0'
gem 'jquery-ui-rails', '~> 6.0.1'
gem 'devise',       '~> 4.7.1'
gem 'cancancan',    '~> 1.15.0'
gem 'carrierwave',  '~> 1.3.2'
gem 'mini_magick',  '~> 4.9.4'
gem 'breadcrumbs',  '~> 0.1.6'
gem 'rake',         '~> 12.3.3'
gem 'rubyzip',      '>= 1.2.1'
gem 'zip-zip'       # rubyzip 1.x.x breaks gems depending on rubyzip 0.9 interface
gem 'dotenv-rails', '~> 0.9.0'
gem 'paranoia',     '~> 2.4.2'  # upgrade to rails 5
gem 'puma'

# removing assets group per http://railscasts.com/episodes/415-upgrading-to-rails-4
gem 'sass-rails',   '~> 5.0.4'
gem 'uglifier',     '~> 2.7.2'


group :test do
  gem 'minitest'
  gem 'capybara', '~> 3.35'
  gem 'poltergeist'
  gem 'database_cleaner', '~> 1.5.1'
  gem 'shoulda-matchers', '2.4.0'
  gem 'rspec-rails', '~> 5.0'
  gem 'factory_girl_rails', '~> 4.0'
  gem 'cucumber-rails',  '~> 1.4.0', :require => false
end

group :development do
  gem 'listen'
  gem 'better_errors'
  gem 'binding_of_caller'
end

group :development,:test do
  gem 'pry'
  gem 'sqlite3'
  gem 'launchy'
end
