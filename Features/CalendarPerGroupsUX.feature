Feature: Calendar per group management

Background:
Given the calendar page is open
And shifts are loaded
And shift holidays are loaded

 
Scenario: Load calendar after selecting a group
Given the user opens the group selection modal
When the user selects a group
Then the selected group should be stored in local storage
And the calendar should load for the selected group and year
And the selected group name should be displayed in the header


Scenario: Restore previously selected group from local storage
Given a group id exists in local storage
When the page loads
Then the calendar should load automatically for that group
 

Scenario: Change year
Given a group is selected
When the user clicks on another active year
Then the calendar should reload for the selected year


#UI
Scenario: Select a day
Given a calendar month is displayed
When the user clicks on a day cell
Then the day should become selected
And the selection should be highlighted
#

Scenario: Edit shift by double clicking a day
Given a calendar day exists
When the user double-clicks the day
Then the day should enter edit mode
And the shift code input should be focused

Scenario: Edit shift by typing a number
Given a day cell is focused
When the user presses a numeric key
Then edit mode should start
And the typed number should appear in the input

Scenario: Change shift using shift code input
Given the day is in edit mode
When the user enters a valid shift code
Then the shiftId of the day should be updated
 
Scenario: Open shift lookup modal
Given a day is in edit mode
When the user clicks the shift list button
Then the shift lookup modal should open

Scenario: Select shift from modal
Given the shift modal is open
When the user selects a shift
Then the selected day shiftId should be updated

Scenario: Cycle holiday type using keyboard
  Given a day is selected
  When the user presses "F6"
  Then the holiday type should cycle between:
    | Type      |
    | None      |
    | Official  |
    | Weekend   |
    | Special   |
  And the shift should update accordingly

Scenario: Show tooltip for holiday or Ramadan
Given a day has holiday or Ramadan flag
When the user hovers over the day
Then a tooltip should be displayed


