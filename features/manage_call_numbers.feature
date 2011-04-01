Feature: Manage Call Numbers
    In order to allow for users to select reservable resources based upon proximity to subject areas they are interested in,
    we allow administrators to manage call_numbers and assign them to a floor.

Scenario: Fail to register a call_number
    Given a library named "Widener"
    And an administrator
    And I am on the call_number "new" page
    When I fill in "Description" with "Call foo"
    And I press "Create"
    Then I should see "Could not add that Call Number"

Scenario: Register new call_number successfully
    Given a library named "Widener"
    And an administrator
    And I am on the call_number "new" page
    When I fill in "Call number" with "CN-5"
    And I fill in "Description" with "Call Number 5"
    And I check "Floor 1"
    And I check "Floor 3"
    And I press "Create"
    Then I should see "CN-5"
    And I should see "Floor 3"
    And I should see "Added that Call Number"

Scenario: View a call number page
    Given a library named "Widener"
    And a call_number of "CN-1"
    And an administrator
    And I am on the call_number "show" page for "CN-1"
    Then I should see "Floor 1"

Scenario: Edit a call number
    Given a library named "Widener"
    And a call_number of "CN-1"
    And an administrator
    When I am on the call_number "edit" page
    And I check "Floor 1"
    And I check "Floor 2"
    And I press "Update"
    Then I should see "Floor 1"
    And I should see "Floor 2"

Scenario: Register a new call_number without a floor
    Given a library named "Widener"
    And an administrator
    And I am on the call_number "new" page
    When I fill in "Description" with "Call Number 6"
    When I fill in "Call number" with "CN-6"
    And I press "Create"
    Then I should see "Call Number 6"
    And I should see "CN-6"
   
Scenario: Register a new call_number with a floor
    Given a library named "Widener"
    And an administrator
    And I am on the call_number "new" page
    When I fill in "Description" with "Call Number 6"
    When I fill in "Call number" with "CN-6"
    And I check "Floor 2"
    And I press "Create"
    Then I should see "Call Number 6"
    And I should see "CN-6"
    And I should see "Floor 2"
