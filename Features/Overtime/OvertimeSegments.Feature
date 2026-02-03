Feature: Overtime Segment Identification

  Background:
    Given a shift from "08:00:00" to "17:00:00"
    And a lunch break exists from "12:00:00" to "13:00:00"

  Scenario: Categorizing work outside shift hours
    When an employee clocks in at "07:00:00" and clocks out at "18:30:00"
    Then the system should identify:
      | Type    | From     | To       | Duration |
      | Before  | 07:00:00 | 08:00:00 | 01:00:00 |
      | Between | 12:00:00 | 13:00:00 | 01:00:00 |
      | After   | 17:00:00 | 18:30:00 | 01:30:00 |

  Scenario: Mid-day Break Overtime calculation with partial absence
    Given the employee worked through the lunch break (12:00 to 13:00)
    But the employee has a mid-day absence segment from "12:00:00" to "12:15:00"
    When the "Between" overtime is calculated
    Then the "potentialOvertime" should be "00:45:00"
    And the "grossOvertime" should be "00:45:00"