Feature: Employee Dynamic Values
    As an Admin
    I want to assign dynamic values to employees
    So that employee attributes can be configured using admin-defined dropdown options

    Scenario: Dropdown shows only active options for a field
        Given a dynamic value field exists with Key "nationality"
        And dynamic value options exist for field "nationality":
            | Code | Title     | IsActive |
            | IR   | Iranian | true     |
            | AZ   | Azerbaijani | false    |
        When I open employee "266" profile and edit field "nationality"
        Then the dropdown options should include "Iranian"
        And the dropdown options should not include "Azerbaijani"

    Scenario: Assign a dropdown dynamic value to an employee
        Given a dynamic value field exists with Key "nationality"
        And a dynamic value option exists for field "nationality" with Code "IR" and Title "Iranian"
        When I set employee "266" dynamic field "nationality" to option "IR"
        Then employee "266" should have dynamic value "nationality" set to "IR"

    Scenario: Prevent assigning an option that does not belong to the field
        Given a dynamic value field exists with Key "nationality"
        And a dynamic value field exists with Key "language"
        And an option exists for field "language" with Code "Fa"
        When I set employee "266" dynamic field "nationality" to option "Fa"
        Then the operation should fail with business error "DynamicValueOptionMismatch"
