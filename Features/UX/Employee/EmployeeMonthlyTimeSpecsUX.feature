Feature: Employee Monthly Time Specs 

 Background:
    Given the Employee Monthly Time Specs page is opened
    And CreateOrEditEmployeeMonthlyTimeSpec modal exists

  Scenario: Load employee monthly time specs
    When the page requests employee monthly time specs
    Then the system should call getAll service
    And the table should display the results

  Scenario: Search using filter text
    Given user enters text in search box
    When search is triggered
    Then filtered results should be loaded

  Scenario: Filter by employee display name
    Given employee filter value is entered
    When filter is applied
    Then matching records should be displayed

  Scenario: Reset filters
    When user clicks reset filters
    Then filterText should be empty
    And employeeDisplayPropertyFilter should be empty
    And table should reload

  Scenario: Create new Employee Monthly Time Spec
    When user clicks create button
    Then CreateOrEditEmployeeMonthlyTimeSpec modal should open in create mode

  Scenario: Edit Employee Monthly Time Spec
    Given a record exists in table
    When user clicks edit
    Then CreateOrEditEmployeeMonthlyTimeSpec modal should open in edit mode

  Scenario: Delete Employee Monthly Time Spec
    Given a record exists
    When user confirms delete
    Then delete service should be called
    And table should reload
    And success notification should be shown

  Scenario: Export to Excel
    When user clicks export to Excel
    Then export service should be called
    And Excel file should be downloaded


 
  Scenario: Open modal in create mode
    When show is called without id
    Then a new EmployeeMonthlyTimeSpec DTO should be created
    And modal should be visible

  Scenario: Open modal in edit mode
    Given an employeeMonthlyTimeSpecId exists
    When show is called with id
    Then getEmployeeMonthlyTimeSpecForEdit should be called
    And modal should be visible
    And employee data should be populated

  Scenario: Select employee from lookup modal
    When user clicks pick employee
    Then employee lookup modal should open

  Scenario: Set selected employee
    Given employee is selected in lookup modal
    When modalSave event fires
    Then employeeMonthlyTimeSpec.employeeId should be set
    And employeeDisplayProperty should be updated

  Scenario: Clear employee selection
    When user clicks remove employee button
    Then employeeId should be null
    And employeeDisplayProperty should be empty

  Scenario: Prevent save without employee
    Given employeeId is empty
    When user clicks save
    Then error message should be shown
    And save should stop

  Scenario: Save new Employee Monthly Time Spec
    Given modal is in create mode
    And employeeId exists
    When save is clicked
    Then createOrEdit service should be called
    And modal should close
    And modalSave event should emit

  Scenario: Update Employee Monthly Time Spec
    Given modal is in edit mode
    When save is clicked
    Then createOrEdit service should be called
    And modalSave event should emit

n