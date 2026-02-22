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

Scenario Outline: Prevent create employment type when required field is missing
  Given the create employment type modal is open
  When the user leaves <field> empty
  And clicks on Save
  Then an error message <message> should be shown
  And the employment type should not be saved

Examples:
  | field | message            |
  | code  | کد را وارد کنید     |
  | title | عنوان را وارد کنید |


Scenario: Create employment type with invalid time
  Given the create employment type modal is open
  When the user enters invalid time 
  And clicks on Save
  Then an error message listing invalid time fields should be displayed
  And the employment type should not be saved



Scenario Outline: Filter employment types
  Given employment types exist
  When the user enters <value> in <filter> filter
  Then only matching employment types should be shown

Examples:
  | filter | value |
  | code   | FT01  |
  | title  | رسمی  |



Scenario Outline: Paid leave accrual type controls visible fields
  Given the create or edit employment type modal is open
  When the user selects <type> as paid leave accrual type
  Then <visibleFields> should be visible and enabled
  And <hiddenFields> should not be visible

Examples:
  | type    | visibleFields                    | hiddenFields               |
  | Daily   | seconds,minutes                  | days,hours                 |
  | Monthly | days,hours,minutes               | seconds                    |
  | Yearly  | days,hours,minutes               | seconds                    |

