Feature: Manage Reservation
    In order to allow for users to select and reserve reservable resources,
    we allow users to make reservations.

	Scenario: Register new reservation
    Given a library named "Widener"
    And a library_floor named "Floor 1"
    And a logged in user of type "user"
    And a reservable_asset named "Timmy"
    And I am on the reservation "new" page
    # Start Date is set by form
		And I select "10 days from today" as the reservation "End date" date
    And I check "Agree to Terms of Service?"
    And I press "Create Reservation"
    And I should see "Floor 1"
    And I should see "Timmy"
    And I should see "Added that Reservation"

	Scenario: View a reservation page
    Given a library named "Widener"
    And a logged in user of type "admin"
    And a reservation of "9001"
    And I am on the reservation "show" page for "9001"
		And I should see "Timmy"
    And I should see "Start Date:"
    And I should see "End Date:"

	Scenario: Edit a reservation
	    Given a library named "Widener"
	    And a library_floor named "Floor 1"
      And a logged in user of type "admin"
      And a reservation of "9001"
      When I am on the reservation "edit" page
      And I select "30 days from today" as the reservation "Start date" date
	    And I press "Update Reservation"
	    Then I should see "Reservation updated"

	Scenario: Delete a reservation
    Given a library named "Widener"
		And a library_floor named "Floor 1"
    And a logged in user of type "admin"
    And I am on the reservation "show" page for "9001"
    When I click ".action-delete"
    Then I should see "Deleted reservation 9001"
