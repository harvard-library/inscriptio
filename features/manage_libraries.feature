Feature: Manage libraries
    In order to provide a container for floors and call numbers
    And administrator
    wants to be able to add, edit, delete, and otherwise manage floors.

Scenario: Register a new library, but fail.
    Given an administrator
    And I am on the library "new" page
    When I fill in "Name" with "Foobar"
    And I press "Create"
    Then I should see "Could not create that library"

Scenario: Register new library
    Given an administrator
    And I am on the library "new" page
    When I fill in "Name" with "name 1"
    And I fill in "Url" with "http://example.com"
    And I fill in "Address 1" with "address_1 1"
    And I fill in "Address 2" with "address_2 1"
    And I fill in "City" with "city 1"
    And I fill in "State" with "state 1"
    And I fill in "Zip" with "zip 1"
    And I fill in "Latitude" with "latitude 1"
    And I fill in "Longitude" with "longitude 1"
    And I fill in "Contact info" with "contact_info 1"
    And I fill in "Description" with "description 1"
    And I fill in "Tos" with "Be excellent to each other"
    And I fill in "Bcc" with "nobody@nowhere.net"
    And I fill in "From" with "nobody@thelibrary.museum"
    And I press "Create"
    Then I should see "name 1"
    And I should see "Added that library"
    And I should see a link to "http://example.com"

Scenario: Edit a library
    Given an administrator
    And a library named "Widener"
    And I am on the library "edit" page
    When I fill in "Name" with "Widener-foo"
    And I press "Update"
    Then I should see "Widener-foo updated"
    And I should see "Widener-foo"

Scenario: Delete a library
    Given an administrator
    And a library named "Widener"
    And I am on the library "index" page
    When I delete the library named "Widener"
    Then I should see "Deleted Widener"
    And I should not see an element "a:contains('Widener')"
    And I should see "Pusey"