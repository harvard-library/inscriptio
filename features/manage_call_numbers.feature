Feature: Manage Call Numbers
    In order to allow for users to select reservable resources based upon proximity to subject areas they are interested in,
    we allow administrators to manage call_numbers and assign them to a floor.

Scenario: Fail to register a call_number
    Given a library named "Widener"
    And a logged in user of type "admin"
    And I am on the call_number "new" page
    When I fill in "Description" with "Call foo"
    And I press "Create"
    Then I should see "Could not add that Call Number"

Scenario: Register new call_number successfully
    Given a library named "Widener"
    And a logged in user of type "admin"
    And I am on the call_number "new" page
    When I fill in "Call number" with "CN-5"
    And I fill in "Description" with "Call Number 5"
    And I check "Floor 1"
    And I check "Floor 3"
    And I press "Create"
    Then I should see "CN-5"
    And I should see "Added that Call Number"
    When I follow "CN-5"
    Then I should see "Floor 3"

Scenario: Register a new call_number without a floor
    Given a library named "Widener"
    And a logged in user of type "admin"
    And I am on the call_number "new" page
    When I fill in "Description" with "Call Number 6"
    When I fill in "Call number" with "CN-6"
    And I press "Create"
    Then I should see "CN-6"
    And I should see "Added that Call Number"

Scenario: View a call number page
    Given a library named "Widener"
    And a call_number of "CN-1"
    And a logged in user of type "admin"
    And I am on the call_number "show" page for "CN-1"
    Then I should see "Floor 1"

Scenario: Edit a call number
    Given a library named "Widener"
    And a call_number of "CN-1"
    And a logged in user of type "admin"
    When I am on the call_number "edit" page
    And I check "Floor 1"
    And I check "Floor 2"
    And I press "Update"
    Then I should see "Floor 1"
    And I should see "Floor 2"
    And I should see "CN-1 updated"

@javascript
Scenario: Delete a call number
    Given a library named "Widener"
    And a logged in user of type "admin"
    And I am on the call_number "index" page
    When I delete the call_number named "CN-1"
    Then I should see "Deleted call number CN-1"
    And I should see "CN-2"
