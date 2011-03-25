Given /^a library with an id of (\d+)$/ do |arg1|
  @library = Library.find(1)
end

Then /^the library should have a floor named "([^"]*)"$/ do |arg1|
  @library.floors.find(:first,:conditions => {:name => arg})
end
