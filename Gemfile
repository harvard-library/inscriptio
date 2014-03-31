source 'http://rubygems.org'

gem 'rails',        '3.2.17'
gem 'pg',           '~> 0.17.0'
gem 'formtastic',   '~> 2.2.1'
gem 'acts_as_list', '~> 0.3.0'
gem 'jquery-rails', '~> 3.1.0'
gem 'jquery-ui-rails', '~> 4.2.0'
gem 'devise',       '~> 3.1.1'
gem 'cancan',       '~> 1.6.0'
gem 'carrierwave',  '~> 0.9.0'
gem 'mini_magick',  '~> 3.6.0'
gem 'breadcrumbs',  '~> 0.1.6'
gem 'rake',         '~> 10.2.0'
gem 'rubyzip',      '~> 1.0.0'
gem 'zip-zip'       # rubyzip 1.x.x breaks gems depending on 0.9 interface
gem 'dotenv-rails', '~> 0.9.0'
# Temporarily using specific commit on Paranoia
# Switch this to Paranoia 1.3.x+ once x > 3
gem 'paranoia', :git => 'git://github.com/radar/paranoia.git', :ref => 'd8c9ce4b498c753efe5171e7014a99974e149f45'
gem 'foreigner',    '~> 1.6.1' # Gem providing foreign key support for ActiveRecord
group :assets do
  gem 'sass-rails',   '~> 3.2.6'
  gem 'coffee-rails', '~> 3.2.2'
  gem 'uglifier',     '~> 2.2.1'
end

group :test do
  gem 'cucumber-rails',  '~> 1.4.0', :require => false
end

group :development do
  gem 'capistrano',        '~> 3.1.0'
  gem 'capistrano-rails',  '~> 1.0.0'
  gem 'capistrano-rvm',    '~> 0.1.1'
  gem 'capistrano-bundler','~> 1.1.2'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'hirb'
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
