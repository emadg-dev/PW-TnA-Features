Feature: Employee Management
  As an HR admin
  I want to create or edit employee information
  So that employee data is stored correctly with valid rules

Scenario: Create a new employee with valid data
  Given the user is on the employee create form
  And employment type is selected
  And organization unit is selected
  And education degree is selected
  And hire date is entered
  And all time fields are valid
  When the user clicks on save
  Then the employee should be saved successfully
  And success message should be shown


Scenario Outline: Prevent save when required employee field is missing
  Given the user is on the employee form
  And "<field>" is not selected
  When the user clicks on save
  Then an error message "<message>" should be shown
  And employee should not be saved

Examples:
  | field             | message                         |
  | employment type   | نوع استخدام را انتخاب کنید      |
  | organization unit | واحد سازمان را انتخاب کنید      |
  | education degree  | تحصیلات را انتخاب کنید          |


Scenario: Employee age is less than 10 years
  Given the user enters a birth date less than 10 years ago
  When the user clicks on save
  Then an error message "سن باید حداقل 10 سال باشد" should be shown


Scenario: Termination date is before hire date
  Given the user enters a hire date
  And enters a termination date before hire date
  When the user clicks on save
  Then an error message "تاریخ پایان همکاری نمی تواند قبل از تاریخ استخدام باشد" should be shown


Scenario: Invalid time format entered
  Given the user enters invalid time in one or more time fields
  When the user clicks on save
  Then an error message listing invalid time fields should be shown
  And employee should not be saved



Scenario: Invalid national ID
  Given the user enters an invalid national ID
  When the user clicks on save
  Then an error message "کد ملی نامعتبر است" should be shown


Scenario: Update employee snapshot
  Given the user opens employee snapshot edit mode
  And snapshot year and month are set
  When the user clicks on save
  Then the snapshot should be updated successfully


Scenario: Edit employee with valid data
  Given the user is on the employee edit form
  And employee data is already loaded
  When the user updates some fields with valid values
  And clicks on save
  Then the employee data should be updated successfully
  And a success message should be shown


Scenario: Delete employee successfully
  Given the delete confirmation modal is open
  When the user confirms the deletion
  Then the employee should be removed from the list
  And a success message should be shown

Scenario Outline: Prevent saving a employee with invalid data
  Given I am on the <mode> employee page
  And I have admin role
  When I fill in the employee form with invalid data
  And I click the save button
  Then the employee should not be saved
  And I should see validation error messages

Examples:
  | mode   |
  | create |
  | edit   |
