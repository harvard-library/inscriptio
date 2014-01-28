Feature: Manage Reservable Asset Types
    In order to allow for users to select reservable resources based on their type,
    we allow administrators to manage reservable_asset_types.

	Scenario: Fail to register a reservable_asset_type
    Given a library named "Widener"
    And a logged in user of type "admin"
    And I am on the reservable_asset_type "new" page
    When I fill in "Name" with "Asset foo"
    And I press "Create"
    Then I should see "New Reservable Asset Type"
    And I should see an element "div#notice_error"

	Scenario: Register new reservable_asset_type successfully
    Given a library named "Widener"
    And a logged in user of type "admin"
    And I am on the reservable_asset_type "new" page
    When I fill in "Name" with "Carrel"
		And I select "Widener" from "Library"
    And I fill in "Minimum reservation time in days" with "1"
    And I fill in "Maximum reservation time in days" with "3"
    And I fill in "Max concurrent users" with "3"
    And I fill in "Slots" with "A,B,C"
    And I fill in "Welcome message" with "Hello, this is a carrel."
    And I fill in "Expiration extension time in days" with "1"
    And I select "Administrator" from "User types"
    And I attach the file "public/images/rails.png" to "Upload a Photo"
    #used ids here to work around capybara trouble with input nested in label
    And I check "Access Code"
    And I check "Requires Moderation"
    And I press "Create"
    Then I should see "Carrel"
    And I should see "Widener"
		And I should see "Hello, this is a carrel."
    And I should see "Administrator"
    And I should see "Added that Reservable Asset Type"

	Scenario: View a reservable_asset_type page
	    Given a library named "Widener"
	    And a reservable_asset_type of "Carrel"
	    And a logged in user of type "admin"
	    And I am on the reservable_asset_type "show" page for "Carrel"
	    Then I should see "Carrel"
      And I should see "Widener"
      And I should see "Welcome to carrel"

	Scenario: Edit a reservable_asset_type
	    Given a library named "Widener"
	    And a reservable_asset_type of "Carrel"
	    And a logged in user of type "admin"
	    When I am on the reservable_asset_type "edit" page
	    And I fill in "Welcome message" with "Hello, this is an updated carrel."
	    And I press "Update"
	    Then I should see "Hello, this is an updated carrel."

	Scenario: Delete a reservable_asset_type
	    Given a library named "Widener"
	    And a logged in user of type "admin"
	    And I am on the reservable_asset_type "index" page
	    When I delete the reservable_asset_type named "Carrel"
	    Then I should see "Deleted reservable asset type Carrel"
