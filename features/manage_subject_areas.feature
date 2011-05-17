Feature: Manage Subject Areas
    In order to allow for users to select reservable resources based upon proximity to subject areas they are interested in,
    we allow administrators to manage subject_areas and assign them to a floor.

	Scenario: Fail to register a subject_area
	    Given a library named "Widener"
	    And an administrator
	    And I am on the subject_area "new" page
	    When I fill in "Description" with "Subject foo"
	    And I press "Create"
	    Then I should see "Could not add that Subject Area"

	Scenario: Register new subject_area successfully
	    Given a library named "Widener"
	    And an administrator
	    And I am on the subject_area "new" page
	    When I fill in "Name" with "Archeology"
	    And I fill in "Description" with "Bones and stuff."
	    And I check "Floor 1"
	    And I check "Floor 3"
	    And I press "Create"
	    Then I should see "Archeology"
	    And I should see "Floor 3"
	    And I should see "Added that Subject Area"

	Scenario: View a subject area page
	    Given a library named "Widener"
	    And a subject_area of "Archeology"
	    And an administrator
	    And I am on the subject_area "show" page for "Archeology"
	    Then I should see "Floor 1"

	Scenario: Edit a subject area
	    Given a library named "Widener"
	    And a subject_area of "Archeology"
	    And an administrator
	    When I am on the subject_area "edit" page
	    And I check "Floor 1"
	    And I check "Floor 2"
	    And I press "Update"
	    Then I should see "Floor 1"
	    And I should see "Floor 2"

	Scenario: Register a new subject area without a floor
	    Given a library named "Widener"
	    And an administrator
	    And I am on the subject_area "new" page
	    When I fill in "Description" with "Cells and stuff."
	    When I fill in "Name" with "Biology"
	    And I press "Create"
	    Then I should see "Cells and stuff."
	    And I should see "Biology"

	Scenario: Delete a subject area
	    Given a library named "Widener"
	    And an administrator
	    And I am on the subject_area "index" page
	    When I delete the subject_area named "Archeology"
	    Then I should see "Deleted subject area Archeology"
	    And I should see "Biology"

