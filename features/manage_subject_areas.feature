Feature: Manage Subject Areas
    In order to allow for users to select reservable resources based upon proximity to subject areas they are interested in,
    we allow administrators to manage subject_areas and assign them to a floor.

	Scenario: Fail to register a subject_area
	    Given a library named "Widener"
      And a logged in user of type "admin"
	    And I am on the subject_area "new" page
      And I fill in "Description" with "Subject foo"
	    And I press "Create"
	    Then I should see "Could not add that Subject Area"

	Scenario: Register new subject_area successfully
	    Given a library named "Widener"
	    And a logged in user of type "admin"
	    And I am on the subject_area "new" page
	    When I fill in "Name" with "Archeology"
	    And I fill in "Description" with "Bones and stuff."
	    And I press "Create"
	    Then I should see "Archeology"
      And I should see "Added that Subject Area"
      Given I am on the subject_area "show" page for "Archeology"
      Then I should see "Bones and stuff"

	Scenario: View a subject area page
	    Given a library named "Widener"
	    And a subject_area of "Phrenology"
	    And a logged in user of type "admin"
	    And I am on the subject_area "show" page for "Phrenology"

	Scenario: Edit a subject area
	    Given a library named "Widener"
	    And a subject_area of "Phrenology"
	    And a logged in user of type "admin"
	    When I am on the subject_area "edit" page
      And I fill in "Name" with "Headbumpology"
	    And I press "Update"
	    And I am on the subject_area "show" page for "Headbumpology"
      And I should see "Headbumpology"

	Scenario: Delete a subject area
	    Given a library named "Widener"
	    And a logged in user of type "admin"
	    And I am on the subject_area "index" page
	    When I delete the subject_area named "Phrenology"
	    Then I should see "Deleted subject area Phrenology"
