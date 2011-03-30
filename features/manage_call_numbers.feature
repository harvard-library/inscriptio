Feature: Manage call_numbers
  In order to allow for users to select reservable resources based upon proximity to subject areas they are interested in,
  we allow administrators to manage call_numbers and assign them to a floor.

  Scenario: Register new call_number with a failure or two
    Given a library named "Widener"
    And an administrator
    And I am on the call_number "new" page
    When I fill in "Description" with "Call Number 5"
    And I select "Floor 1" from "Floors"
    And I select "Floor 3" from "Floors"
    And I press "Create"
    Then I should see "Could not add that Call Number"
    When I fill in "Call number" with "CN-5"
    And I press "Create"
    Then I should see "Call Number 5"
    And I should see "Floor 1"
    And I should see "Floor 3"
    When I am on the library_floor "show" page for "Floor 1"
    Then I should see "CN-5"

@wip
  Scenario: View a call number page.
    Given a library named "Widener"
    And an administrator
    And I am on the call_number "show" page for "CN-1"
    Then show me the page

  Scenario: Register a new call_number without a floor
    Given a library named "Widener"
    And an administrator
    And I am on the call_number "new" page
    When I fill in "Description" with "Call Number 6"
    When I fill in "Call number" with "CN-6"
    And I press "Create"
    Then I should see "Call Number 6"
    And I should see "CN-6"
    
