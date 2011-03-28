Feature: Manage libraries
  In order to [goal]
  [stakeholder]
  wants [behaviour]
  
  Scenario: Register new library
    Given I am on the new library page
    When I fill in "Name" with "name 1"
    And I fill in "Url" with "url 1"
    And I fill in "Address 1" with "address_1 1"
    And I fill in "Address 2" with "address_2 1"
    And I fill in "City" with "city 1"
    And I fill in "State" with "state 1"
    And I fill in "Zip" with "zip 1"
    And I fill in "Latitude" with "latitude 1"
    And I fill in "Longitude" with "longitude 1"
    And I fill in "Contact info" with "contact_info 1"
    And I fill in "Description" with "description 1"
    And I press "Create"
    Then I should see "name 1"
    And I should see "url 1"
    And I should see "address_1 1"
    And I should see "address_2 1"
    And I should see "city 1"
    And I should see "state 1"
    And I should see "zip 1"
    And I should see "latitude 1"
    And I should see "longitude 1"
    And I should see "contact_info 1"
    And I should see "description 1"

  Scenario: Delete library
    Given the following libraries:
      |name|url|address_1|address_2|city|state|zip|latitude|longitude|contact_info|description|
      |name 1|url 1|address_1 1|address_2 1|city 1|state 1|zip 1|latitude 1|longitude 1|contact_info 1|description 1|
      |name 2|url 2|address_1 2|address_2 2|city 2|state 2|zip 2|latitude 2|longitude 2|contact_info 2|description 2|
      |name 3|url 3|address_1 3|address_2 3|city 3|state 3|zip 3|latitude 3|longitude 3|contact_info 3|description 3|
      |name 4|url 4|address_1 4|address_2 4|city 4|state 4|zip 4|latitude 4|longitude 4|contact_info 4|description 4|
    When I delete the 3rd library
    Then I should see the following libraries:
      |Name|Url|Address 1|Address 2|City|State|Zip|Latitude|Longitude|Contact info|Description|
      |name 1|url 1|address_1 1|address_2 1|city 1|state 1|zip 1|latitude 1|longitude 1|contact_info 1|description 1|
      |name 2|url 2|address_1 2|address_2 2|city 2|state 2|zip 2|latitude 2|longitude 2|contact_info 2|description 2|
      |name 4|url 4|address_1 4|address_2 4|city 4|state 4|zip 4|latitude 4|longitude 4|contact_info 4|description 4|
