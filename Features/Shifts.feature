
Feature: Shift Management
  As an Admin, I want to manage staff shifts so that the schedule is ready for work time calculations.

  Background:
    Given I am logged in as an Admin
    And I am on the shift management page

  # CREATE
  Scenario: Create a new shift
    When I enter valid shift information like
      | Field     | Value    |
      | Code      | 100      |
      | Title     | FullTime |
      | StartTime | 08:00:00 |
      | EndTime   | 17:00:00 |
    And I save the shift
    Then the shift should appear in the shift list
    And I should see a "Shift created successfully" notification

  # Check Unique Code and Title
  Scenario Outline: Unique field validation
    Given a shift exists with <field> "<value>"
    When I attempt to create a shift with <field> "<value>"
    Then the shift should not be saved
    And I should see a uniqueness error for "<field>"

    Examples:
      | field | value |
      | Code  | 101   |
      | Title | Night |

  # DELETE
  Scenario: Successful deletion of an unassigned shift
    Given a shift exists that is not assigned to any Group Cycle
    When I delete the shift
    Then the shift should be removed from the system

  Scenario: Blocked deletion of an assigned shift
    Given a shift exists
    And the shift is currently used in a Group Cycle
    When I attempt to delete the shift
    Then the shift should still exist in the system
    And I should see a dependency warning

  # UPDATE
  Scenario: Update shift scheduling and equivalents
    Given I am editing the shift with code "101"
    And the current StartTime is "08:00:00"
    When I update the following fields:
      | Field                | Value      |
      | Title                | Morning v2 |
      | AbsenceDayEquivalent | 06:00:00   |
    And I save the changes
    Then the shift should reflect the new values
    And the "StartTime" should still be "08:00:00"

  # SEARCH
  Scenario: Search for a shift by code
    Given a shift exists with code "100" and title "FullTime"
    When I search for "100"
    Then the shift "FullTime" should be visible in the results
    And shifts with other codes should be hidden

  #VALIDATION
  Scenario Outline: Validate shift end time relative to duration days
    When I enter the following shift details:
      | Field        | Value      |
      | StartTime    | 22:00:00   |
      | EndTime      | 06:00:00   |
      | DurationDays | <duration> |
    And I save the shift
    Then the system should <result_action>

    Examples:
      | duration | result_action                                     |
      | 0        | show an error "End Time must be after Start Time" |
      | 1        | save the shift successfully                       |
      | 2        | save the shift successfully                       |


