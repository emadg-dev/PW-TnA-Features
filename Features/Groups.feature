@groups
Feature: Group Management

Scenario: Admin opens group form
  Given I am on the  group page
  And I have admin role
  When I click the create group button
  Then I should see the group input fields

  Scenario: Admin creates a new group
  Given I am on the create group page
  And I have admin role
  When I fill in valid group information
  And I click the save button
  Then the group should be created successfully
  And I should see a success notification


Scenario: Prevent creating a duplicate group
  Given a group already exists
  When I fill in the group inputs with duplicate data
  And I click the create button
  Then the group should not be created
  And I should see a notification that the group is duplicated

Scenario: Delete a group
  Given a group exists
  When I click the delete button
  Then the group should be removed
  And I should see a delete notification
  And the group list should be updated

Scenario: Edit a group
  Given a group exists
  And the group information should be displayed
  When I change the group value fields
  And I click the save button
  Then updated information saved successfully

Scenario: Search for a group
  Given a list of groups exists
  When I search for an existing group
  And I click the search button
  Then the matching group should be displayed

Scenario Outline: Prevent saving a group with invalid data
  Given I am on the <mode> group page
  And I have admin role
  When I fill in the group form with invalid data
  And I click the save button
  Then the group should not be saved
  And I should see validation error messages

Examples:
  | mode   |
  | create |
  | edit   |



@groupCycles
Feature: Group Cycle Management

Scenario: Generate group cycles based on start date and number of days
  Given I am on the group cycle page
  And a group exists
  When I enter a valid start date
  And I enter the number of days
  And I move focus out of the number of days field
  Then the group cycles should be generated automatically
  And the generated cycles should match the start date and number of days


Scenario: Regenerate group cycles when inputs are changed
  Given group cycles are already generated
  When I update the start date or number of days
  And I move focus out of the updated field
  Then the group cycles should be regenerated
  And the old cycles should be replaced with the new ones


@groupCyclesGenerated
Feature: Group Cycle Shift Assignment

Background:
  Given I am on the group cycle page
  And a group exists
  And shifts exist in the system

Scenario: Display generated group cycle table with shifts
  Given group cycles are generated
  Then I should see the group cycle table
  And each day should have a shift column

Scenario: Open shift input on double click
  Given the group cycle table is displayed
  When I double click on a shift cell for a day
  Then the shift input box should be opened

Scenario: Assign a shift using shift selection modal
  Given the shift input box is opened
  When I open the shift selection modal
  And I select a shift from the modal
  Then the selected shift should be assigned to the day
  And the shift input box should be closed

Scenario: Assign a shift by entering shift code
  Given the shift input box is opened
  When I enter a valid shift code
  And I confirm the input
  Then the shift should be assigned to the day
  And the shift input box should be closed

Scenario: Prevent assigning an invalid shift code
  Given the shift input box is opened
  When I enter an invalid shift code
  And I confirm the input
  Then the shift should not be assigned

Scenario: Update shift for an existing day
  Given a shift is already assigned to a day
  When I double click the shift cell
  And I assign a different shift
  Then the shift for that day should be updated




