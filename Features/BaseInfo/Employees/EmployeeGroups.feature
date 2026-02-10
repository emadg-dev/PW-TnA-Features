Feature: Employee group assignment history
    As an Admin
    I want to change an employee's group from a date, either indefinitely or for a period
    So that the EmployeeGroups history remains consistent and the employee's current group is correct

    Background:
        Given I am logged in as an Admin
        And the tenant is "Default"
        And an employee "266" exists
        And groups exist:
            | GroupId | Title   |
            | 10      | RnD     |
            | 20      | Support |
            | 30      | HR      |

    Scenario: Current employee group is determined by the interval containing today's date
        Given today's date is "1404-01-15"
        And employee "266" has EmployeeGroups history:
            | StartDate  | EndDate    | GroupId |
            | 1404-01-01 | 1404-01-31 | 10      |
            | 1404-02-01 | null       | 20      |
        When I query the current group for employee "266"
        Then the current group should be "RnD"

    Scenario: Change employee group indefinitely from a given date
        Given employee "266" has EmployeeGroups history:
            | StartDate  | EndDate | GroupId |
            | 1404-01-01 | null    | 10      |
        When I change employee "266" group to "Support" starting from "1404-02-01" indefinitely
        Then employee "266" should have EmployeeGroups history:
            | StartDate  | EndDate    | GroupId |
            | 1404-01-01 | 1404-01-31 | 10      |
            | 1404-02-01 | null       | 20      |

    Scenario: Change employee group for a period and revert to the previous group afterwards
        Given employee "266" has EmployeeGroups history:
            | StartDate  | EndDate | GroupId |
            | 1404-01-01 | null    | 10      |
        When I change employee "266" group to "HR" from "1404-02-01" to "1404-02-10"
        Then employee "266" should have EmployeeGroups history:
            | StartDate  | EndDate    | GroupId |
            | 1404-01-01 | 1404-01-31 | 10      |
            | 1404-02-01 | 1404-02-10 | 30      |
            | 1404-02-11 | null       | 10      |

    Scenario: Overwrite existing history when the entered period overlaps two existing intervals
        Given employee "266" has EmployeeGroups history:
            | StartDate  | EndDate    | GroupId |
            | 1404-01-01 | 1404-01-31 | 10      |
            | 1404-02-01 | 1404-02-15 | 20      |
            | 1404-02-16 | null       | 30      |
        When I change employee "266" group to "HR" from "1404-01-20" to "1404-02-10"
        Then the employee group history for "266" should be rewritten to:
            | StartDate  | EndDate    | GroupId |
            | 1404-01-01 | 1404-01-19 | 10      |
            | 1404-01-20 | 1404-02-10 | 40      |
            | 1404-02-11 | 1404-01-31 | 10      |
            | 1404-02-11 | 1404-02-15 | 20      |
            | 1404-02-16 | null       | 30      |
        And the history should have no overlapping date ranges
        And the latest EmployeeGroups row should have EndDate null

    Scenario: Overwrite existing history when the entered period fully contains two existing intervals
        Given employee "266" has EmployeeGroups history:
            | StartDate  | EndDate    | GroupId |
            | 1404-01-01 | 1404-01-10 | 10      |
            | 1404-01-11 | 1404-01-20 | 20      |
            | 1404-01-21 | null       | 30      |
        When I change employee "266" group to "HR" from "1404-01-05" to "1404-01-25"
        Then the employee group history for "266" should be rewritten to:
            | StartDate  | EndDate    | GroupId |
            | 1404-01-01 | 1404-01-04 | 10      |
            | 1404-01-05 | 1404-01-25 | 40      |
            | 1404-01-26 | null       | 10      |
        And the history should have no overlapping date ranges
        And the latest EmployeeGroups row should have EndDate null

        



