Feature: Manage Reservable Asset
    In order to allow for users to select and reserve reservable resources,
    we allow administrators to manage reservable_assets.

		#   	Scenario: No Reservable Assets Defined.
		#     	Given a library named "Widener"
		# And a library_floor named "Floor 1"
		#     	And an administrator
		#     	And the reservable_assets have been deleted
		#     	And I am on the reservable_asset "index" page
		#     	Then I should see "No reservable assets for this floor yet."

	Scenario: Register new reservable_asset
	    Given a library named "Widener"
		And a library_floor named "Floor 1"
	    And an administrator
	    And I am on the reservable_asset "new" page
		When I select "Floor 1" from "Floor"
		And I select "Carrel" from "Reservable asset type"
	    And I fill in "Min reservation time" with "1 month"
	    And I fill in "Max reservation time" with "3 months"
		And I fill in "Max concurrent users" with "3"
		And I fill in "Reservation time increment" with "1 week"
		And I fill in "General info" with "this is an asset on a floor"
		And I fill in "Location" with "on the right"
		And I attach the file "public/images/rails.png" to "Upload a Photo"
	    And I press "Create"
		Then I should see "Floor 1"
		And I should see "Carrel"
	    And I should see "1 month"
	    And I should see "3 months"
		And I should see "3"
		And I should see "1 week"
		And I should see "this is an asset on a floor"	
		And I should see "1 week"
		And I should see "on the right"
	    And I should see "Added that Reservable Asset"

	Scenario: View a reservable_asset page
	    Given a library named "Widener"
		And a library_floor named "Floor 1"
	    And a reservable_asset of "1"
	    And an administrator
	    And I am on the reservable_asset "show" page for "1"
		Then I should see "Floor 1"
		And I should see "Carrel"
		And I should see "left"
	    And I should see "1 month"
	    And I should see "3 months"
		And I should see "4"
		And I should see "1 week"
		And I should see "this is a carrel on a floor"

	Scenario: Edit a reservable_asset_type
	    Given a library named "Widener"
	    And a library_floor named "Floor 1"
	    And a reservable_asset of "1"
	    And an administrator
	    When I am on the reservable_asset "edit" page
	    And I fill in "General info" with "this is an updated asset"	
	    And I press "Update"
	    Then I should see "this is an updated asset"

	Scenario: Delete a reservable_asset
	    Given a library named "Widener"
		And a library_floor named "Floor 1"
	    And an administrator
	    And I am on the reservable_asset "index" page
	    When I delete the reservable_asset named "1"
	    Then I should see "Deleted reservable asset 1"

