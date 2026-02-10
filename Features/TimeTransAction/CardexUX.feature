Feature: Cardex management 

Background:
Given Cardex page is opened
And wage codes are loaded
And employee information exists
 
Scenario: Initialize Cardex page with saved employee
Given employee data exists in local storage
When the page initializes
Then employeeId should be loaded from storage
And employee name should be displayed
And cardex list should be loaded

Scenario: Load cardex records for employee
Given employeeId exists
When getDailyLeaveOrMissions is called
Then cardex records should be retrieved 
And wage code titles should be mapped
And remaining cardex should be stored

Scenario: Filter cardex by start date
Given user selects start date
When start date changes
Then cardex list should be reloaded

Scenario: Filter cardex by end date
Given user selects end date
When end date changes
Then cardex list should be reloaded

Scenario: Invalid date range validation
Given start date is later than end date
When validation runs
Then dateError should be set

Scenario: Select employee from selector modal
When user selects an employee
Then employeeId should be updated
And employee name should be saved in local storage
And cardex should reload

Scenario: Create new Daily Leave Or Mission from cardex
When user clicks create button
Then Cardex modal should open in create mode

Scenario: Delete Daily Leave Or Mission
Given a cardex record exists
When user confirms delete
Then delete service should be called
And cardex list should reload

Scenario: Export cardex to Excel
When user clicks export
Then Excel file should be downloaded

Scenario: Reset filters
When resetFilters is executed
Then all filters should be cleared
And cardex list should reload

Background:
Given Cardex modal is opened
And employeeId is available

Scenario: Open modal in create mode
When show is called without id
Then a new DailyLeaveOrMissionDto should be created
And employeeId should be set
And modal should be visible

Scenario: Open modal in edit mode
Given a cardex exists
When show is called with id
Then record should be loaded from service
And start and end dates should be converted to Shamsi
And duration should be formatted
And modal should be visible

Scenario: Auto-set end date when start date is selected
Given end date is empty
When user selects start date
Then end date should be set equal to start date

Scenario: Validate date range
Given end date is earlier than start date
When validation runs
Then dateError should be set

Scenario: Calculate equivalent duration
Given start date and end date exist
When updateEquivalentDuration is triggered
Then equivalent duration service should be called
And durationCardex should be displayed

Scenario: Prevent save when start date is missing
When user clicks save
And start date is empty
Then error alert should be shown

Scenario: Prevent save when end date is missing
When user clicks save
And end date is empty
Then error alert should be shown

