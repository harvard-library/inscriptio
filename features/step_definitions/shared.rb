Given /^an administrator$/ do
end

Given /^a library named "([^"]*)"$/ do |arg1|
  @library = Library.find_or_create_by_name(arg1)
end

When 'I delete the $object_type named "$name"' do |object_type,name|
  case object_type
  when "floor"
    floor = @library.floors.find(:first, :conditions => {:name => name})
    within("#floor-#{floor.id}") do
      click_link "delete-#{floor.id}"
    end

  when "library"
    click_link "delete-#{@library.id}"

  when "call_number"
    call_number = CallNumber.find_by_call_number(name)
    click_link "delete-#{call_number.id}"
  end
end

Given /^a library_floor named "([^"]*)"$/ do |arg1|
  @floor = @library.floors.find(:first, :conditions => {:name => arg1})
end

Given /^a call_number of "([^"]*)"$/ do |arg1|
  @call_number = CallNumber.find_by_call_number(arg1)
end

When 'I am on the $object_type "$page_name" page' do|object_type,page_name|
  if object_type == 'library_floor'
    case page_name
    when 'index'
      visit(library_floors_path(@library))
    when 'new'
      visit(new_library_floor_path(@library))
    when 'edit'
      visit(edit_library_floor_path(@library, @floor))
    end

  elsif object_type == 'call_number'
    case page_name
    when 'index'
      visit(call_numbers_path)
    when 'new'
      visit(new_call_number_path)
    when 'edit'
      visit(edit_call_number_path(@call_number))
    end

  elsif object_type == 'library'
    case page_name
    when 'index'
      visit(libraries_path)
    when 'new'
      visit(new_library_path)
    when 'edit'
      visit(edit_library_path(@library))
    end
  end
end

When 'I am on the $object_type "show" page for "$floor_name"' do |object_type, object_name|
  case object_type
  when 'library_floor'
    floor = @library.floors.find(:first, :conditions => {:name => object_name})
    visit(library_floor_path(@library,floor))
  when 'call_number'
    call_number = CallNumber.find(:first, :conditions => { :call_number => object_name })
    visit(call_number_path(call_number))
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

Then /^I should see a link to "([^"]*)"$/ do |link_href|
  page.should have_xpath(%Q|//a[@href="#{link_href}"]|)
end
