Given /^the following libraries:$/ do |libraries|
  Library.create!(libraries.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) library$/ do |pos|
  visit libraries_path
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following libraries:$/ do |expected_libraries_table|
  expected_libraries_table.diff!(tableish('table tr', 'td,th'))
end
