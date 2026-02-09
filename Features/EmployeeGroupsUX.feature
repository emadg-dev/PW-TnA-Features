Feature: Employee group assignment management

Background:
Given the Employee Groups page is open
And the employee selector component is available

Scenario: Select employee from selector
When the user clicks "Select Employee"
And chooses an employee from the selector
Then the selected employee name should be displayed
And employeeId should be stored
And the employee groups list should reload

Scenario: Prevent creating group without employee selection
Given no employee is selected
When the user clicks "Create New Employee Group"
Then a warning notification should be shown

Scenario: Open create employee group modal
Given an employee is selected
When the user clicks "Create New Employee Group"
Then the create employee group modal should open
And start date should be initialized
And end date type should be "indefinite"

Scenario: Select group using lookup modal
Given the create employee group modal is open
When the user clicks "Pick Group"
And selects a group
Then groupId should be set
And group display name should appear

Scenario: Clear selected group
Given a group is selected
When the user clicks the clear group button
Then groupId should become null
And group display should be empty

Scenario: Set start date using Persian date picker
Given the modal is open
When the user selects a start date
Then employeeGroup.startDate should be set
And the date control value should update

Scenario: Set end date as specific date
Given the modal is open
When the user selects "specific end date"
And selects a date
Then employeeGroup.endDate should be set

Scenario: Set end date as indefinite
Given the modal is open
When the user selects "Until Further Notice"
Then endDate should be null

Scenario: Validate end date after start date
Given start date is entered
And end date is earlier than start date
Then a validation error message should be shown

Scenario: Prevent saving without start date
Given the modal is open
When the user clicks Save without start date
Then an error alert should be displayed

Scenario: Prevent saving without group
Given the modal is open
When the user clicks Save without selecting group
Then an error alert should be displayed

Scenario: Prevent saving when date validation fails
Given start date is after end date
When the user clicks Save
Then saving should be blocked
And an error alert should be shown

Scenario: Create employee group successfully
Given the modal is open
And required fields are valid
When the user clicks Save
Then createOrEdit API should be called
And a success notification should be shown
And the modal should close
And the employee groups list should reload

Scenario: Edit employee group
Given an employee group exists
When edit modal is opened
Then existing group data should be loaded
And start and end dates should be converted to Shamsi format

Scenario: Save edited employee group
Given the edit modal is open
When the user clicks Save
Then createOrEdit API should be called
And a success notification should be shown

Scenario: Filter employee groups list
Given the list page is open
When the user types in search box
Then the employee groups list should reload

Scenario: Reset filters
Given filters are applied
When the user clicks Reset
Then all filters should be cleared
And the list should reload

Scenario: Export employee groups to Excel
Given the employee groups list is visible
When the user clicks Export to Excel
Then the Excel file should be downloaded
