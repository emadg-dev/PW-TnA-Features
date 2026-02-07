Feature: Work Deduction Summation

  Scenario: Aggregate all components into total deduction
    Given the daily row has the following calculated values:
      | Component       | Value    |
      | LateArrivalTime | 00:25:00 |
      | EarlyLeaveTime  | 00:10:00 |
      | AbsenceBetween  | 00:45:00 |
    When the total work deduction sum is calculated
    Then the "TotalWorkDeductionTime" should be "01:20:00"

  Scenario: Zero deductions for unscheduled days
    Given a daily row has no shift assigned
    When the total work deduction sum is calculated
    Then all deduction components should be "00:00:00"
    And the "TotalWorkDeductionTime" should be "00:00:00"