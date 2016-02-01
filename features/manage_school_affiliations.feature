Feature: Manage School Affiliations
  In order to identify school affiliations, 
  we allow administrators to create, edit and delete school_affiliations

Scenario: A new school_affiliation is set up
  Given a logged in user of type "admin"
  And I follow "School Affiliations"
  And I follow "New School Affiliation"
  And I am on the school_affiliation "new" page
  And I fill in "Name*" with "Miss Demerest School of MisManagement"
  And I press "Create School affiliation"
  Then I should see "Added that School Affiliation"
  And I am on the school_affiliation "index" page
  And I should see "Miss Demerest School of MisManagement"

Scenario: A school_affiliation is edited
  Given a logged in user of type "admin"
  And I follow "School Affiliations"
  And I follow "New School Affiliation"
  And I am on the school_affiliation "new" page
  And I fill in "Name*" with "Miss Demerest School of MisManagement"
  And I press "Create School affiliation"
  Then I should see "Added that School Affiliation"
  And I should see "Miss Demerest School of MisManagement"
  And I am on the school_affiliation "index" page
  Given a school_affiliation named "Miss Demerest School of MisManagement"
  And I am on the school_affiliation "edit" page
  And I fill in "Name*" with "Miss Demerest School of MANAGEMENT"
  And I press "Update School affiliation"
  Then I should see "Miss Demerest School of MANAGEMENT updated"
  And I am on the school_affiliation "index" page

Scenario: A school_affiliation is deleted
  Given a logged in user of type "admin"
  And I follow "School Affiliations"
  And I follow "New School Affiliation"
  And I am on the school_affiliation "new" page
  And I fill in "Name*" with "Miss Demerest School of MisManagement"
  And I press "Create School affiliation"
  Then I should see "Added that School Affiliation"
  And I should see "Miss Demerest School of MisManagement"
  And I am on the school_affiliation "index" page
#  Given a school_affiliation named "Miss Demerest School of MisManagement"
  And I delete the school_affiliation named "Miss Demerest School of MisManagement"
  Then I should see "Deleted school affiliation Miss Demerest School of MisManagement"
