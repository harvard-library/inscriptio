Feature: Manage User Types
    In order to allow for reservation controls on reservable asset types based on user type,
    we allow administrators to manage user_types.

	Scenario: Fail to register a user_type
	    Given a logged in user of type "admin"
	    And I am on the user_type "new" page
	    When I fill in "Name" with ""
	    And I press "Create"
	    Then I should see "Could not add that User Type"
		And show me the page

	Scenario: Register new user_type successfully
	    Given an administrator
	    And I am on the user_type "new" page
	    When I fill in "Name" with "Undergraduate"
	    And I press "Create"
	    Then I should see "Undergraduate"
	    And I should see "Added that User Type"

	Scenario: View a user_type page
	    Given a user_type of "Undergraduate"
	    And an administrator
	    And I am on the user_type "show" page for "Undergraduate"
	    Then I should see "Undergraduate"

	Scenario: Edit a user_type
	    Given a user_type of "Undergraduate"
	    And an administrator
	    When I am on the user_type "edit" page
	    And I fill in "Name" with "Graduate"
	    And I press "Update"
	    Then I should see "Graduate"

	Scenario: Delete a user_type
	    Given an administrator
	    And I am on the user_type "index" page
	    When I delete the user_type named "Graduate"
	    Then I should see "Deleted user type Graduate"
	    And I should see "Undergraduate"
		And I should see "Post-Doc"

