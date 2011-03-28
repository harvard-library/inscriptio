Feature: Manage floors
  In order to manage floors,
  an administrator 
  wants to be able create, delete, edit, and view floors in the context of a library..
  
  Scenario: No floors defined.
    Given a library named "Widener"
    And an administrator
    And the floors have been deleted
    And I am on the library_floor index page
    Then I should see "No floors for this library yet."

  Scenario: Delete floor
    Given a library named "Widener"
    And an administrator
    When I delete the floor named "Floor 2"
    Then I should see "Deleted floor Floor 2"
    And I should see "Floor 3"

  Scenario: Register new floor
    Given a library named "Widener"
    And an administrator
    And I am on the new library_floor page
    When I fill in "Name" with "Floor 1"
    And I select "Widener" from "Library"
    And I press "Create"
    Then I should see "Floor 1"
    And I should see "in Widener"

  Scenario: Move a floor up within library
    Given a library named "Widener"
    And an administrator
    And I am on the library_floor index page
    When I click the "move_up-2" link on "Floor 2"
    Then I should see "Moved Floor 2 up"

  Scenario: Move a floor down within library
    Given a library named "Widener"
    And an administrator
    And I am on the library_floor index page
    When I click the "move_down-3" link on "Floor 3"
    Then I should see "Moved Floor 3 down"
