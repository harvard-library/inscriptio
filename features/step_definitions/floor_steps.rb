Given /^an administrator$/ do
end

Given /^a library named "([^"]*)"$/ do |arg1|
  @library = Library.find_or_create_by_name(arg1)
end

When /^I delete the floor named "([^"]*)"$/ do |arg1|
  floor = @library.floors.find(:first, :conditions => {:name => arg1})
  visit library_floors_path(@library)
  within("#floor-#{floor.id}") do
    click_link "delete-#{floor.id}"
  end
end

Given /^a library_floor named "([^"]*)"$/ do |arg1|
  @floor = @library.floors.find(:first, :conditions => {:name => arg1})
end

When 'I am on the $object_type "$page_name" page' do|object_type,page_name|
  case page_name
  when 'index'
    visit(send(object_type.pluralize + '_path', @library))
  when 'new'
    visit(send('new_' + object_type + '_path',@library))
  when 'edit'
    visit(send('edit_' + library_floor + '_path', @library, @floor))
  end
end

Given /^the floors have been deleted$/ do
  @library.floors.destroy_all
end

When /^I click the "([^"]*)" link on "([^"]*)"$/ do |link_name, item_name|
  floor = @library.floors.find(:first, :conditions => {:name => item_name})
  within("#floor-#{floor.id}") do
    click_link(link_name)
  end
end                                                                                                                 
