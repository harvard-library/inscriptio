Feature: Manage Reservation Notices
  In order to allow receive various notices about reservations,
  we allow administrators to edit and reset reservation_notices

Scenario: A new reservable asset type has reservation_notices set up
  Given a library named "Widener"
  And a logged in user of type "admin"
  And I am on the reservable_asset_type "new" page
  And I fill in "Name" with "Bongo"
  And I fill in "Minimum reservation time in days" with "3"
  And I fill in "Maximum reservation time in days" with "3"
  And I fill in "Max concurrent users" with "1"
  And I fill in "Slots" with "A"
  And I fill in "Expiration extension time in days" with "3"
  And I select "User" from "User types"
  And I press "Create"
  And I am on the reservation_notice "index" page
  Then I should see "Bongo"
  Then I should see "Approved - Approved" within ".asset_notices.at-bongo"
  And I should see "Pending - Pending" within ".asset_notices.at-bongo"
  And I should see "Declined - Declined" within ".asset_notices.at-bongo"
  And I should see "Waitlist - Waitlist" within ".asset_notices.at-bongo"
  And I should see "Expired - Expired" within ".asset_notices.at-bongo"
  And I should see "Expiring - Expiring" within ".asset_notices.at-bongo"
  And I should see "Cancelled - Cancelled" within ".asset_notices.at-bongo"

@javascript
Scenario: An administrator can reset all reservation notices to initial defaults
  Given a library named "Widener"
  And a logged in user of type "admin"
  And a reservable_asset_type of "Carrel"
  And I am on the reservation_notice "index" page
  And I press "Expand"
  And I follow "Reset Notices"
  And I am on the reservation_notice "index" page
  And I press "Expand"
  Then I should see "Approved - Approved"
  And I should see "Pending - Pending"
  And I should see "Declined - Declined"
  And I should see "Waitlist - Waitlist"
  And I should see "Expired - Expired"
  And I should see "Expiring - Expiring"
  And I should see "Cancelled - Cancelled"

@javascript
Scenario: An administrator can edit a reservation notice
  Given a library named "Widener"
  And a logged in user of type "admin"
  And a reservable_asset_type of "Carrel"
  And I am on the reservation_notice "index" page
  And I press "Expand"
  Given a reservation_notice with status of "Declined"
  And I click "Edit" in my reservation_notice
  And I am on the reservation_notice "edit" page
  And I fill in "Subject" with "Request Declined"
#  And I fill in "Message*" with "Your request has been declined"
  And I fill in "Reply to" with "foo@harvard.edu"
  And I press "Update Reservation notice"
  Then I should see " updated"
  And I press "Expand"
  And I follow "Declined - Request Declined"
  Then I should see "Request Declined"
#  And I should see "Your request has been declined"
  And I should see "foo@harvard.edu"
 