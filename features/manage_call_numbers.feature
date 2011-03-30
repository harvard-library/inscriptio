Feature: Manage call_numbers
  In order to allow for users to select reservable resources based upon proximity to subject areas they are interested in,
  we allow administrators to manage call_numbers and assign them to a floor.
 
  @wip
  Scenario: Register new call_number with a failure or two
    Given a library named "Widener"
    And an administrator
    And I am on the call_number "new" page
    When I fill in "Description" with "Call Number 5"
    And I press "Create"
    Then I should see "Could not add that Call Number"
    And show me the page
    When I fill in "Call number" with "CN-5"
    And I press "Create"
    Then I should see "Call Number 5"

  Scenario: Delete call_number
    Given the following call_numbers:
      ||
      ||
      ||
      ||
      ||
    When I delete the 3rd call_number
    Then I should see the following call_numbers:
      ||
      ||
      ||
      ||
