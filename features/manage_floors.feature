Feature: Manage floors
  In order to manage floors,
  an administrator 
  wants to be able create, delete, edit, and view floors in the context of a library.
  
  Scenario: No floors defined.
    Given a library named "Widener"
    And an administrator
    And the floors have been deleted
    And I am on the library_floor "index" page
    Then I should see "No floors for this library yet."

  Scenario: Delete floor
    Given a library named "Widener"
    And an administrator
    And I am on the library_floor "index" page
    When I delete the floor named "Floor 2"
    Then I should see "Deleted floor Floor 2"
    And I should see "Floor 3"

  Scenario: Register new floor
    Given a library named "Widener"
    And an administrator
    And I am on the library_floor "new" page
    When I fill in "Name" with "Floor 4"
    And I select "Widener" from "Library"
    And I attach the file "public/images/rails.png" to "Upload a Floor Map"
    And I check "CN-2"
    And I check "CN-3"
    And I press "Create"
    Then I should see "Floor 4"
    And I should see "in Widener"
    And I should see "CN-2"
    And I should see "CN-3"

  Scenario: Move a floor up within library
    Given a library named "Widener"
    And an administrator
    And I am on the library_floor "index" page
    When I click the "Move Up" link on "Floor 2"
    Then I should see "Moved Floor 2 up"

  Scenario: Move a floor down within library
    Given a library named "Widener"
    And an administrator
    And I am on the library_floor "index" page
    When I click the "Move Down" link on "Floor 3"
    Then I should see "Moved Floor 3 down"

  Scenario: Attach a map to a floor, save it, and then confirm it's there on the edit form.
    Given a library named "Widener"
    And a library_floor named "Floor 1"
    And an administrator
    And I am on the library_floor "edit" page
    When I attach the file "public/images/rails.png" to "Upload a Floor Map"
    And I press "Update"
    Then I should see "Floor 1 updated"
    And I should see "Map"
    And I am on the library_floor "edit" page
    Then I should see "Current Map"

