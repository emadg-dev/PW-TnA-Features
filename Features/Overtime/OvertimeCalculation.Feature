# language: en

@overtimeCalculation
Feature: Overtime Calculation Based on New Policies

  As a time calculation system, I must be able to calculate authorized and unauthorized overtime
  based on total permits, specific permits, attendance with wage code 2, and policies for holidays and non-holidays.

  Background:
    Given an employee exists with the following specifications
      | Policy                             | Value |
      | MaxAllowedOvertimePerDay           | 04:00 |
      | MaxOverTimePerDay                  | 04:00 |
      | MaxOvertimeBefore                  | 02:00 |
      | MaxOvertimeBetween                 | 02:00 |
      | MaxOvertimeAfter                   | 02:00 |
      | OvertimeWithoutApprovalBefore      | 00:30 |
      | OvertimeWithoutApprovalBetween     | 00:30 |
      | OvertimeWithoutApprovalAfter       | 00:30 |
      | MaxOvertimeOnHoliday               | 08:00 |
      | OvertimeWithoutApprovalOnHoliday   | 01:00 |

  @wageCode2Duration
  Scenario: Populate WageCode2Duration field for overtime segments
    Given the employee has a pre-shift overtime segment from 06:00 to 07:00
    And an entry punch is recorded at 06:00 with "wage code 2" for a duration of 01:00:00
    And the employee has a post-shift overtime segment from 18:00 to 19:00
    And an exit punch is recorded at 19:00 with "wage code 2" for a duration of 01:00:00
    When the overtime calculation process is executed
    Then the "WageCode2Duration" field for the pre-shift overtime segment should be 01:00:00
    And the "WageCode2Duration" field for the post-shift overtime segment should be 01:00:00

  @totalPermit
  Scenario: Convert unauthorized overtime to authorized using a total permit (OvertimeTotal)
    Given the current day is a normal working day (non-holiday)
    And the employee has 03:00:00 of unauthorized overtime, broken down as follows:
      | Type    | OvertimeWithoutPermit |
      | Before  | 01:00:00              |
      | Between | 01:00:00              |
      | After   | 01:00:00              |
    And a total permit "OvertimeTotal" for 02:30:00 is registered for the employee
    When the overtime calculation process is executed
    Then the employee's authorized overtime should be 02:30:00 and unauthorized overtime should be 00:30:00
    And the details of the authorized overtime should be as follows:
      | Type    | OvertimeWithPermit |
      | Before  | 01:00:00           |
      | Between | 01:00:00           |
      | After   | 00:30:00           |

  @specificPermit
  Scenario: Convert unauthorized overtime to authorized using specific permits (Before, After, Between)
    Given the current day is a normal working day (non-holiday)
    And the employee has 03:00:00 of unauthorized overtime in different segments
    And a specific permit "OvertimeBefore" for 00:45:00 is registered for the employee
    And a specific permit "OvertimeAfter" for 01:30:00 is registered for the employee
    When the overtime calculation process is executed
    Then from the unauthorized pre-shift overtime, 00:45:00 is converted to authorized
    And from the unauthorized post-shift overtime, 01:30:00 is converted to authorized
    And the total authorized overtime will be 02:15:00

  @nonHolidayNoPermitWithWageCode2
  Scenario: (Non-holiday) Convert unauthorized overtime to authorized based on wage code 2 in the absence of a permit
    Given the current day is a normal working day (CpgHoliday = 0)
    And no "OvertimeTotal" or "OvertimeBefore" permit is registered for the employee
    And the employee has a pre-shift overtime segment with 01:00:00 of unauthorized overtime
    And for this segment, "WageCode2Duration" is 01:00:00
    When the overtime calculation process is executed
    Then all 01:00:00 of unauthorized overtime is converted to authorized overtime (as it does not exceed the allowed limits)
    And the "MaxOvertimeBefore" and "MaxOverTimePerDay" values are reduced by 01:00:00 respectively

  @nonHolidayNoPermitWithoutWageCode2
  Scenario: (Non-holiday) Convert unauthorized overtime to authorized based on the no-permit limit in the absence of an explicit permit
    Given the current day is a normal working day (CpgHoliday = 0)
    And no "OvertimeTotal" or "OvertimeBefore" permit is registered for the employee
    And the employee has a pre-shift overtime segment with 01:00:00 of unauthorized overtime and no wage code 2
    And the "OvertimeWithoutApprovalBefore" policy is set to 00:30:00
    When the overtime calculation process is executed
    Then an amount of 00:30:00 of unauthorized overtime is converted to authorized overtime
    And authorized overtime will be 00:30:00 and unauthorized overtime will be 00:30:00

  @holidayWithWageCode2
  Scenario: (Holiday) Convert unauthorized overtime to authorized with wage code 2
    Given the current day is a holiday (CpgHoliday = 2)
    And no "OvertimeTotal" or "OvertimeBefore" permit is registered for the employee
    And the employee has a pre-shift overtime segment with 02:00:00 of unauthorized overtime
    And for this segment, "WageCode2Duration" is 02:00:00
    And the "MaxOvertimeOnHoliday" policy is set to 08:00:00
    When the overtime calculation process is executed
    Then all 02:00:00 of unauthorized overtime is converted to authorized overtime
    And the "MaxOvertimeOnHoliday" value is reduced to 06:00:00

  @holidayBetweenSegment
  Scenario: (Holiday) Convert unauthorized between-shift overtime based on holiday limits
    Given the current day is a holiday (CpgHoliday = 1)
    And the employee has 01:30:00 of unauthorized overtime in the between-shift segment
    And the "OvertimeWithoutApprovalOnHoliday" policy is set to 01:00:00
    And the "MaxOvertimeOnHoliday" policy is set to 08:00:00
    When the overtime calculation process is executed
    Then an amount of 01:00:00 of unauthorized overtime is converted to authorized overtime
    And authorized overtime will be 01:00:00 and unauthorized overtime will be 00:30:00
    And the "OvertimeWithoutApprovalOnHoliday" and "MaxOvertimeOnHoliday" values are reduced by 01:00:00 respectively
