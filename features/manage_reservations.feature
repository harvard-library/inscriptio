Feature: Manage Reservation
    In order to allow for users to select and reserve reservable resources,
    we allow users to make reservations.

	Scenario: Register new reservation
	    Given a library named "Widener"
		And a library_floor named "Floor 1"
		And a logged in user of type "user"
	    And I am on the reservation "new" page
	    And I select "2011/05/19" as the reservation "start_date" date
		And I select "2011/06/19" as the reservation "end_date" date
	    And I press "Create"
		And I should see "Floor 1"
		And I should see "Carrel"
	    And I should see "1"
	    And I should see "2011-05-19"
		And I should see "2011-06-19"
	    And I should see "Added that Reservation"
		And show me the page

	Scenario: View a reservation page
	    Given a library named "Widener"
		And a library_floor named "Floor 1"
	    And a reservation of "1"
	    And I am on the reservation "show" page for "1"
		And I should see "Floor 1"
		And I should see "Carrel"
	    And I should see "1"
	    And I should see "2011-05-16"
		And I should see "2011-06-16"

	Scenario: Edit a reservation
	    Given a library named "Widener"
	    And a library_floor named "Floor 1"
	    And a reservation of "1"
	    And an administrator
	    When I am on the reservation "edit" page
		And I select "2011/05/19" as the reservation "start_date" date	
	    And I press "Update"
	    Then I should see "2011-05-19"

	Scenario: Delete a reservation
	    Given a library named "Widener"
		And a library_floor named "Floor 1"
	    And an administrator
	    And I am on the reservation "index" page
	    When I delete the reservation named "1"
	    Then I should see "Deleted reservation 1"

