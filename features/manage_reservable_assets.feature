Feature: Manage Reservable Asset
    In order to allow for users to select and reserve reservable resources,
    we allow administrators to manage reservable_assets.

  	Scenario: No Reservable Assets Defined.
	   	Given a library named "Widener"
      And a library_floor named "Floor 1"
	   	And a logged in user of type "admin"
	   	And the reservable_assets have been deleted
	   	And I am on the reservable_asset_type "index" page
	   	Then I should see "No reservable assets yet."

	Scenario: Register new reservable_asset
    Given a library named "Widener"
    And a logged in user of type "admin"
    And a reservable_asset_type of "Carrel"
    And I am on the reservable_asset "new" page
    When I select "Floor 1" from "Floor"
    And I fill in "Name" with "CAR-EL-ANNE"
    And I fill in "Access Code" with "8675309"
    And I fill in "Location" with "Floating above the others"
    And I fill in "Notes" with "Passing notes is forbidden"
		And I attach the file "public/images/rails.png" to "Upload a Photo"
    And I press "Create"
    Then I should see "Floor 1"
    And I should see "Carrel"
    And I should see "CAR-EL-ANNE"
    And I should see "Added that Reservable Asset"

	Scenario: View a reservable_asset page
	    Given a library named "Widener"
		And a library_floor named "Floor 1"
	    And a reservable_asset named "Timmy"
	    And a logged in user of type "admin"
	    And I am on the reservable_asset "show" page for "Timmy"
		Then I should see "Floor 1"
		And I should see "Carrel"
    And I should see "Timmy Info"

	Scenario: Edit a reservable_asset
	    Given a library named "Widener"
	    And a library_floor named "Floor 1"
	    And a reservable_asset named "Timmy"
	    And a logged in user of type "admin"
	    When I am on the reservable_asset "edit" page
	    And I fill in "Description" with "this is an updated asset"
	    And I press "Update"
	    Then I should see "Timmy updated"
      When I am on the reservable_asset "show" page for "Timmy"
      Then I should see "this is an updated asset"

	Scenario: Delete a reservable_asset
	    Given a library named "Widener"
		And a library_floor named "Floor 1"
	    And a logged in user of type "admin"
	    And I am on the reservable_asset_type "index" page
	    When I delete the reservable_asset named "Timmy"
	    Then I should see "Deleted reservable asset"
      And I should not see an element "a:contains('Timmy')"
