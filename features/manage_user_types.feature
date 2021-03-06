Feature: Manage User Types
    In order to allow for reservation controls on reservable asset types based on user type,
    we allow administrators to manage user_types.

	Scenario: Fail to register a user_type
	    Given a logged in user of type "admin"
	    And I am on the user_type "new" page
	    When I fill in "Name" with ""
	    And I press "Create"
	    Then I should see "Could not add to Widener New User Type"

	Scenario: Register new user_type successfully
	    Given a logged in user of type "admin"
	    And I am on the user_type "new" page
	    When I fill in "Name" with "Undergraduate"
	    And I press "Create"
	    Then I should see "Undergraduate"
	    And I should see "Added Undergraduate to Widener"

	Scenario: View a user_type page
	    Given a user_type of "Undergraduate"
	    And a logged in user of type "admin"
	    And I am on the user_type "show" page for "Undergraduate"
	    Then I should see "Undergraduate"

	Scenario: Edit a user_type
	    Given a user_type of "Undergraduate"
	    And a logged in user of type "admin"
	    When I am on the user_type "edit" page
	    And I fill in "Name" with "Graduate"
	    And I press "Update"
	    Then I should see "Graduate"

	Scenario: Delete a user_type
	    Given a logged in user of type "admin"
      And a user_type of "Graduate"
      And a user_type of "Undergraduate"
	    And I am on the user_type "index" page
	    When I delete the user_type named "Graduate"
	    Then I should see "Deleted Graduate from Widener"
	    And I should see "Undergraduate"
