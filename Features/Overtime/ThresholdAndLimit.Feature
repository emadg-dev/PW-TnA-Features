Feature: Threshold and Limit Policy

  Scenario Outline: Effective Minimum Threshold Selection
    # If one is zero, use the other. If both non-zero, use the minimum.
    Given employee minimum threshold is "<emp_min>"
    And shift minimum threshold is "<shift_min>"
    When calculating the effective threshold
    Then the result should be "<effective>"

    Examples:
      | emp_min  | shift_min | effective |
      | 00:00:00 | 00:00:00  | 00:00:00  |
      | 00:30:00 | 00:00:00  | 00:30:00  |
      | 00:00:00 | 00:15:00  | 00:15:00  |
      | 00:45:00 | 00:20:00  | 00:20:00  |

  Scenario: Enforcement of Max Allowed Overtime
    Given an employee has 3 hours of "Before" work
    And the "MaxAllowedOvertimePerDay" is "01:00:00"
    And "OvertimeWithoutApprovalBefore" is "02:00:00"
    When the policy is applied
    Then "OvertimeWithPermit" should be "01:00:00"
    And "OvertimeWithoutPermit" should be "02:00:00"