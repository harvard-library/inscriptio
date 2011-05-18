Feature: Manage Reservable Asset Types
    In order to allow for users to select reservable resources based on their type,
    we allow administrators to manage reservable_asset_types.

	Scenario: Fail to register a reservable_asset_type
	    Given a library named "Widener"
	    And an administrator
	    And I am on the reservable_asset_type "new" page
	    When I fill in "Name" with "Asset foo"
	    And I press "Create"
	    Then I should see "Could not add that Reservable Asset Type"

	Scenario: Register new reservable_asset_type successfully
	    Given a library named "Widener"
	    And an administrator
	    And I am on the reservable_asset_type "new" page
	    When I fill in "Name" with "Carrel"
		And I select "Widener" from "Library"
	    And I fill in "Min reservation time" with "1 month"
	    And I fill in "Max reservation time" with "3 month"
		And I fill in "Max concurrent users" with "3"
		And I fill in "Reservation time increment" with "1 week"
		And I fill in "Welcome message" with "Hello, this is a carrel."	
		And I fill in "Expiration extension time" with "1 week"
		And I fill in "Moderation held message" with "moderation held"
		And I attach the file "public/images/rails.png" to "Upload a Photo"
	    And I press "Create"
	    Then I should see "Carrel"
		And I should see "Widener"
	    And I should see "1 month"
	    And I should see "3 month"
		And I should see "3"
		And I should see "1 week"
		And I should see "Hello, this is a carrel."	
		And I should see "1 week"
		And I should see "moderation held"
	    And I should see "Added that Reservable Asset Type"

	Scenario: View a reservable_asset_type page
	    Given a library named "Widener"
	    And a reservable_asset_type of "Carrel"
	    And an administrator
	    And I am on the reservable_asset_type "show" page for "Carrel"
	    Then I should see "Carrel"
		And I should see "Widener"
	    And I should see "1 month"
	    And I should see "3 month"
		And I should see "3"
		And I should see "1 week"
		And I should see "this is a carrel"	
		And I should see "1 week"
		And I should see "moderation held"

	Scenario: Edit a reservable_asset_type
	    Given a library named "Widener"
	    And a reservable_asset_type of "Carrel"
	    And an administrator
	    When I am on the reservable_asset_type "edit" page
	    And I fill in "Welcome message" with "Hello, this is an updated carrel."	
	    And I press "Update"
	    Then I should see "Hello, this is an updated carrel."

	Scenario: Delete a reservable_asset_type
	    Given a library named "Widener"
	    And an administrator
	    And I am on the reservable_asset_type "index" page
	    When I delete the reservable_asset_type named "Carrel"
	    Then I should see "Deleted reservable asset type Carrel"

