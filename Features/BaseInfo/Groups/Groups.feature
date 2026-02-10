Feature: Group Management
  As an Admin, I want to manage employee groups so that holiday and overtime rules are correctly applied.

  Background:
    Given I am logged in as an Admin
    And I am on the group management page

  #CREATE
  Scenario: Create a group successfully
    When I create a new group with the following details:
      | Field                  | Value      |
      | Code                   | 1          |
      | Title                  | RnD        |
      | CycleLength            | 7          |
      | CcleStartDate          | 1404/01/01 |
      | IsHolidayEffective     | true       |
      | StartOvertimeOnHoliday | 08:00:00   |
      | EndOvertimeOnHoliday   | 17:00:00   |
    And the groupCycle list is:
      | DayInCycle | DayOfWeek | ShiftId |
      | 1          | 1         | 101     |
      | 2          | 2         | 101     |
      | 3          | 3         | 101     |
    And I save the group
    Then the group "RnD" should appear in the list
    And CalendarPerGroups should be generated from for the current year

  # Check Unique Code and Title
  Scenario Outline: Unique field validation
    Given a group exists with <field> "<value>"
    When I attempt to create a group with <field> "<value>"
    Then the group should not be saved
    And I should see a uniqueness error for "<field>"

    Examples:
      | field | value |
      | Code  | 1     |
      | Title | RnD   |
