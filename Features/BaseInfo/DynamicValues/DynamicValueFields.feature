Feature: Dynamic Value Fields
    As an Admin
    I want to define dynamic fields and their options
    So that employees can be assigned configurable attributes via dropdowns

    Background:
        Given I am logged in as an Admin
        And the tenant is "Default"

    Scenario: Create a dynamic value field successfully
        When I create a dynamic value field with:
            | Name        | Key         | IsActive |
            | Nationality | nationality | true     |
        Then the dynamic value field "Nationality" should be saved successfully
        And the field "nationality" should appear in the dynamic field list

    Scenario Outline: Prevent creating a dynamic field with duplicate Key
        Given a dynamic value field exists with Key "<Key>"
        When I create a dynamic value field with:
            | Name | Key   | IsActive |
            | Any  | <Key> | true     |
        Then the operation should fail with business error "DynamicValueKeyAlreadyExists"

        Examples:
            | Key         |
            | nationality |

    Scenario: Prevent deleting a dynamic field if used by employees
        Given a dynamic value field exists with Key "nationality"
        And employee dynamic values exist for field "nationality"
        When I delete the dynamic value field with Key "nationality"
        Then the operation should fail with business error "DynamicValueInUse"
        And the dynamic value field with Key "nationality" should still exist
