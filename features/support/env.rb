# TL;DR: YOU SHOULD DELETE THIS FILE
#
# This file iwas generated by Cucumber-Rails and is only here to get you a head start
# These step definitions are thin wrappers around the Capybara/Webrat API that lets you
# visit pages, interact with widgets and make assertions about page content.
#
# If you use these step definitions as basis for your features you will quickly end up
# with features that are:
#
# * Hard to maintain
# * Verbose to read
#
# A much better approach is to write your own higher level step definitions, following
# the advice in the following blog posts:
#
# * http://benmabey.com/2008/05/19/imperative-vs-declarative-scenarios-in-user-stories.html
# * http://dannorth.net/2011/01/31/whose-domain-is-it-anyway/
# * http://elabs.se/blog/15-you-re-cuking-it-wrong
#

require 'cucumber/rails'
require 'capybara/poltergeist'

Capybara.default_driver = :rack_test
Capybara.javascript_driver = :poltergeist
Capybara.register_driver :poltergeist do |app|
  options = {
    :js_errors => true,
    :timeout => 120,
    :debug => false,
    :phantomjs_options => ['--disk-cache=false'],
    :inspector => true
  }
  Capybara::Poltergeist::Driver.new(app, options)
end

# Capybara defaults to XPath selectors rather than Webrat's default of CSS3. In
# order to ease the transition to Capybara we set the default here. If you'd
# prefer to use XPath just remove this line and adjust any selectors in your
# steps to use the XPath syntax.
Capybara.default_selector = :css

# By default, any exception happening in your Rails application will bubble up
# to Cucumber so that your scenario will fail. This is a different from how
# your application behaves in the production environment, where an error page will
# be rendered instead.
#
# Sometimes we want to override this default behaviour and allow Rails to rescue
# exceptions and display an error page (just like when the app is running in production).
# Typical scenarios where you want to do this is when you test your error pages.
# There are two ways to allow Rails to rescue exceptions:
#
# 1) Tag your scenario (or feature) with @allow-rescue
#
# 2) Set the value below to true. Beware that doing this globally is not
# recommended as it will mask a lot of errors for you!
#
ActionController::Base.allow_rescue = false

# Remove this line if your app doesn't have a database.
# For some databases (like MongoDB and CouchDB) you may need to use :truncation instead.
DatabaseCleaner.strategy = :truncation
Before do
  FactoryGirl.create_list(:message, 3)
  #Load factories before running cucumber.
  @library = FactoryGirl.create(:library, :name => 'Widener')
  @pusey = FactoryGirl.create(:library, :name => 'Pusey')
  (1..5).each do |i|
    FactoryGirl.create(:floor, :library => @library, :name => "Floor #{i}")
  end
  @rat = FactoryGirl.create(:reservable_asset_type, :name => 'Carrel', :library => @library)
  @asset = FactoryGirl.create(:reservable_asset, :name => 'Timmy', :reservable_asset_type => @rat, :min_reservation_time => 2, :max_reservation_time => 60, :floor => Floor.find_by_name('Floor 1'))
  @subject_area = FactoryGirl.create(:subject_area, :name => "Phrenology", :library_id => @library.id)
  (1..4).each do |i|
    FactoryGirl.create(:call_number, :floors => [Floor.find_by_name('Floor 1')], :call_number => "CN-#{i}", :subject_area_id => @subject_area.id)
  end
  @user_t = FactoryGirl.create(:user_type, :name => 'User', :reservable_asset_types => [@rat], :library_id => @library.id)
  @admin = FactoryGirl.create(:user, :email => 'admin@email.com', :password => '123456', :admin => true, :user_types => [])
  @user = FactoryGirl.create(:user, :email => 'user@email.com', :password => '123456', :user_types => [@user_t])
  @reservation = FactoryGirl.create(:reservation, :id => 9001, :reservable_asset => @asset, :user => @user, :status_id => Status[:approved], :start_date => Date.today, :end_date => Date.today + 59)
end


#TODO - figure out multiple profiles for running cucumber tasks.
# It seems that selenium is unable to attach files in chrome.
# That kind of makes sense, but also makes testing more annoying.

#Capybara.default_driver = :selenium
#Capybara.app_host = "http://127.0.0.1:3000"
#Capybara.register_driver :selenium do |app|
#  Capybara::Driver::Selenium.new(app, :browser => :firefox)
#end

#World(Capybara)
