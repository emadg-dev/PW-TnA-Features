Feature: Calendar year management and holiday configuration

Background:
Given the calendar page is opened
And the current Jalali year is loaded
And the calendar data is retrieved from the server

Scenario: Load calendar for selected year
Given the page is initialized
When the system sets the current year
Then the calendar months should be loaded
And the loading indicator should disappear

Scenario: Change calendar year
Given the calendar page is visible
When the user clicks a year in the header
Then the selected year should be updated
And the system should check whether the year is active
And the calendar should reload for that year


Scenario: Activate calendar year
Given the selected year is not active
When the user clicks the activate calendar button
And confirms the activation
Then the system should activate the calendar for the selected year
And a success notification should be shown
And the year should become active

Scenario: Prevent editing when year is inactive
Given the selected year is not active
When the user clicks a calendar day
Then no holiday state should change
 

Scenario: Toggle holiday state for a day
Given the calendar year is active
When the user clicks a day
Then the holiday state should cycle between:
| State |
| None |
| Official |
| Weekend |
| Special |
And the day should be added to modified days list


Scenario: Save modified calendar days
Given there are modified days
When the user clicks Save
Then the modified days should be mapped to edit DTO objects
And the editList API should be called
And a success notification should be shown

 
Scenario: Show tooltip for holiday or Ramadan
Given a day has holiday or Ramadan flag
When the user hovers over the day
Then a tooltip should be displayed

Scenario: Open Ramadan configuration modal
Given the calendar year is active
When the user clicks the Ramadan button
Then the Ramadan modal should be opened

Scenario: Apply Ramadan date range
Given the Ramadan modal is open
And the user selects start and end dates
When the user confirms the selection
Then all calendar days within the range should be marked as Ramadan
And the modal should close

Scenario: Apply multiple Ramadan ranges
Given the Ramadan modal is open
And the user adds a second date range
When the user confirms
Then both ranges should be applied to the calendar
And matching days should be marked as Ramadan

Scenario: Reset previous Ramadan values before applying new range
Given some days are already marked as Ramadan
When a new Ramadan range is applied
Then previous Ramadan flags should be cleared
And the new range should be applied

And 

Scenario: Display calendar months
Given the calendar is loaded
Then all months of the selected year should be displayed
And each month should contain calendar weeks and days
