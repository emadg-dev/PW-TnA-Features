Feature: Employment Type Management
    As As an HR admin
    I want to create, edit and delete employment types
    So  that employment types are managed correctly in the system


Scenario: Create employment type with valid data
  Given the user is on Employment Types page
  When the user clicks on "Create"
  And enters a valid code
  And enters a valid title
  And enters a valid max transferable leave time
  And selects leave transfer type
  And selects paid leave accrual type
  And clicks on Save
  Then the employment type should be created successfully
  And a success message should be displayed
  And the modal should be closed

Scenario: Create employment type without code
  Given the create employment type modal is open
  When the user leaves code empty
  And clicks on Save
  Then an error message "کد را وارد کنید" should be shown
  And the employment type should not be saved

Scenario: Create employment type without title
  Given the create employment type modal is open
  When the user leaves title empty
  And clicks on Save
  Then an error message "عنوان را وارد کنید" should be shown
  And the employment type should not be saved

Scenario: Create employment type with invalid time
  Given the create employment type modal is open
  When the user enters invalid time 
  And clicks on Save
  Then an error message listing invalid time fields should be displayed
  And the employment type should not be saved

Scenario: Edit employment type with valid data
  Given an employment type exists
  And the user opens edit employment type modal
  When the user updates some fields
  And clicks on Save
  Then the employment type should be updated successfully
  And a success message should be displayed


Scenario: Edit employment type without changes
  Given the edit employment type modal is open
  And no fields are modified
  When the user clicks on Save
  Then the employment type should remain unchanged
  And no validation error should be shown

Scenario: View employment types list
  Given employment types exist
  When the user opens Employment Types page
  Then a list of employment types should be displayed


Scenario: Filter employment types by code
  Given employment types exist
  When the user enters a code in code filter
  Then only matching employment types should be shown


Scenario: Filter employment types by title
  Given employment types exist
  When the user enters a title in title filter
  Then only matching employment types should be shown


Scenario: Reset employment type filters
  Given filters are applied
  When the user clicks on Reset
  Then all filters should be cleared
  And the full list should be displayed


Scenario: Open delete confirmation dialog
  Given an employment type exists
  When the user clicks on Delete
  Then a confirmation dialog should be displayed


Scenario: Cancel employment type deletion
  Given the delete confirmation dialog is open
  When the user cancels deletion
  Then the employment type should not be deleted


Scenario: Delete employment type successfully
  Given an employment type exists
  And the delete confirmation dialog is open
  When the user confirms deletion
  Then the employment type should be deleted
  And a success message should be displayed
  And the list should be refreshed


Scenario: Export employment types to Excel
  Given employment types exist
  When the user clicks on Export to Excel
  Then an Excel file should be downloaded


Scenario: Select Daily paid leave accrual type
  Given the create or edit employment type modal is open
  When the user selects "Daily" as paid leave accrual type
  Then leave accrual seconds field should be visible and enabled
  And leave accrual days field should not be visible
  And leave accrual hours field should not be visible
  And leave accrual minutes field should be visible and enabled


Scenario: Select Monthly paid leave accrual type
  Given the create or edit employment type modal is open
  When the user selects "Monthly" as paid leave accrual type
  Then leave accrual days field should be visible and enabled
  And leave accrual hours field should be visible and enabled
  And leave accrual minutes field should be visible and enabled
  And leave accrual seconds field should not be visible


Scenario: Select Yearly paid leave accrual type
  Given the create or edit employment type modal is open
  When the user selects "Yearly" as paid leave accrual type
  Then leave accrual days field should be visible and enabled
  And leave accrual hours field should be visible and enabled
  And leave accrual minutes field should be visible and enabled
  And leave accrual seconds field should not be visible

