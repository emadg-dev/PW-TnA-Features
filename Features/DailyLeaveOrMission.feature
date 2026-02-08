Feature: Daily Leave Or Mission modal behavior

Background:
Given the Daily Leave Or Mission modal component is initialized
And wage codes are loaded
And employee information is available



Scenario: Open modal in edit mode
Given a Daily Leave Or Mission record exists
When the modal is opened with an id
Then record data should be loaded
And wage code display name should be shown
And start date should be shown
And end date should be shown
And duration should be shown

Scenario: Auto-set end date when selecting start date
Given end date is empty
When the user selects start date
Then end date should be set equal to start date

Scenario: Validate start and end dates
Given start date is selected
And end date is earlier than start date
When validation runs
Then dateError should be set

Scenario: Update equivalent duration when dates change
Given start date and end date are selected
When duration calculation runs
Then equivalent duration should be calculated
And formatted duration should be displayed

Scenario: Update equivalent duration when wage changes
Given start date and end date are selected
When wage code changes
Then equivalent duration should be recalculated

Scenario: Prevent save when wage code is not selected
When the user clicks Save without selecting wage code
Then an error message should be shown

Scenario: Prevent save when start date is missing
When the user clicks Save without start date
Then an error message should be shown

Scenario: Prevent save when end date is missing
When the user clicks Save without end date
Then an error message should be shown

Scenario: Prevent save when date validation fails
Given dateError exists
When Save is clicked
Then saving should stop

Scenario: Prevent save when invalid time fields exist
Given invalidTimeFields contains items
When Save is clicked
Then an error alert should be displayed


Scenario: Select employee from lookup
When employee lookup modal is opened
And an employee is selected
Then employeeId should be updated
And employee display name should be updated

Scenario: Clear employee selection
Given an employee is selected
When employee is cleared
Then employeeId should be null
And employee display name should be empty
