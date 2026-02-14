Feature: Dynamic Value Options
  As an Admin
  I want to manage dropdown options for a dynamic field
  So that users can select valid values for employees

Scenario: Add options to a dynamic dropdown field
  Given a dynamic value field exists with Key "nationality" and DataType "Dropdown"
  When I add dynamic value options for field "nationality":
    | Code | Title      | IsActive |
    | IR   | Iranian  | true     |
    | AZ   | Azerbaijani  | true     |
  Then the field "nationality" should have options:
    | Code | Title      |
    | IR   | Iranian  |
    | AZ   | Azerbaijani  |

Scenario Outline: Prevent creating duplicate option codes within the same field
  Given a dynamic value field exists with Key "nationality"
  And an option exists for field "nationality" with Code "<Code>"
  When I add a dynamic value option for field "nationality" with Code "<Code>" and Title "Duplicate"
  Then the operation should fail with business error "DynamicValueOptionCodeAlreadyExists"

  Examples:
    | Code |
    | IR   |

Scenario: Prevent deleting an option if assigned to an employee
  Given a dynamic value field exists with Key "nationality"
  And a dynamic value option exists for field "nationality" with Code "IR"
  And employee "266" has dynamic value "nationality" set to option "IR"
  When I delete the option "IR" from field "nationality"
  Then the operation should fail with business error "DynamicValueOptionInUse"
  And the option "IR" should still exist for field "nationality"

