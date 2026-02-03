Feature: Holiday Overtime Rules

  Background:
    Given the current day is marked as a "CpgHoliday"

  Scenario: Between overtime on holidays uses holiday policy
    Given "OvertimeWithoutApprovalOnHoliday" is "04:00:00"
    And the employee worked "02:00:00" during the holiday break hours
    When the holiday policy is applied
    Then the "Between" overtime "WithPermit" should be "02:00:00"

  Scenario: Before/After overtime on holidays requires WageCode 2
    Given the employee worked "01:00:00" before shift start
    And no WageCode 2 was provided
    And no manual "OvertimeBeforePerDay" was approved
    When the holiday policy is applied
    Then the "Before" overtime "WithPermit" should be "00:00:00"
    And "WithoutPermit" should be "01:00:00"