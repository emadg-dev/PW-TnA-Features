Feature: Early Leave Calculation

  Background:
    Given a shift ends at "17:00:00"
    And the shift "AllowedEarlyDeparture" is "00:15:00"
    And the "ParkingDelay" is "00:15:00"

  Scenario: Subtract overlapping hourly leave from early leave gap
    Given the employee physically exits at "15:00:00"
    And a Leave transaction exists from "16:00:00" to "17:00:00"
    When the early leave is calculated
    Then the initial gap should be "02:00:00"
    And the "LastWageCodeBeforeEndDuration" should be "01:00:00"
    And the "finalEarlyLeave" before forgiveness should be "01:00:00"

  Scenario Outline: Apply Min-Forgiveness threshold logic
    Given the employee has "MaxHurryPerDay" of "<max_hurry>"
    And the adjusted gap (after leave) is "<adj_gap>"
    When the early leave is calculated
    Then the final "EarlyLeaveTime" should be "<result>"

    Examples:
      | max_hurry | adj_gap  | result   | Logic                                             |
      | 00:10:00  | 00:08:00 | 00:00:00 | adj_gap < Min(10m, 15m, 15m); Forgiven            |
      | 00:20:00  | 00:12:00 | 00:00:00 | adj_gap < Min(20m, 15m, 15m); Forgiven            |
      | 00:05:00  | 00:10:00 | 00:05:00 | adj_gap > Min(5m, 15m, 15m); gap - max_hurry (5m) |