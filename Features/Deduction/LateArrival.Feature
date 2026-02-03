
Feature: Late Arrival Calculation

  Background:
    Given a shift starts at "08:00:00"
    And the "AllowedDelay" is "00:10:00"

  Scenario Outline: Calculate late arrival using Max Allowed grace logic
    Given the employee has "MaxDelayPerDay" of "<max_delay>"
    And the "ParkingDelay" for the day is "<parking>"
    When the employee arrives at "<arrival>"
    Then the "LateArrivalTime" should be "<result>"

    Examples:
      | max_delay | parking  | arrival  | result   | Note                                     |
      | 00:00:00  | 00:00:00 | 08:05:00 | 00:00:00 | Within Shift AllowedDelay (10m)          |
      | 00:15:00  | 00:05:00 | 08:12:00 | 00:00:00 | Within Max(10m, 15m, 5m) = 15m           |
      | 00:05:00  | 00:20:00 | 08:18:00 | 00:00:00 | Within Max(10m, 5m, 20m) = 20m           |
      | 00:10:00  | 00:00:00 | 08:30:00 | 00:20:00 | (30m delay) - (10m personal allowance)   |

    Scenario: Identify first effective entry by skipping early pairs
    Given an employee has the following transaction pairs:
      | Type  | Time     | Note                               |
      | Entry | 07:00:00 |                                    |
      | Exit  | 07:45:00 | This pair ends before shift start  |
      | Entry | 08:20:00 | This is the first effective entry  |
      | Exit  | 17:00:00 |                                    |
    When the late arrival is calculated
    Then the "firstEffectiveEntry" should be "08:20:00"