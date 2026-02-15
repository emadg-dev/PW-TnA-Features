Feature: Group Cycle Management

  Scenario: Successfully create group with matching cycle entries
    Given I am creating a new group with "CycleLength" set to 3
    When I provide the following 3 cycle entries:
      | DayInCycle | DayOfWeek | ShiftId |
      | 1          | 1         | 101     |
      | 2          | 2         | 101     |
      | 3          | 3         | 102     |
    And I save the group
    Then the group and its 3 cycles should be saved successfully

  Scenario: Successfully create group when null shift is used only the day after a 2-day shift
    Given I am creating a new group with "CycleLength" set to 3
    And the following shifts exist:
      | ShiftId | Title       | StartTime | EndTime  | DurationDays |
      | 601     | TwoDayShift | 08:00:00  | 08:00:00 | 2            |
      | 602     | DayShift    | 09:00:00  | 17:00:00 | 0            |
    When I provide the following 3 cycle entries:
      | DayInCycle | DayOfWeek | ShiftId |
      | 1          | 1         | 601     |
      | 2          | 2         | null    |
      | 3          | 3         | 602     |
    And I save the group
    Then the group and its 3 cycles should be saved successfully

  Scenario Outline: Reject null shift unless it is the day after a 2-day shift
    Given I am creating a new group with "CycleLength" set to 3
    And the following shifts exist:
      | ShiftId | Title       | StartTime | EndTime  | DurationDays |
      | 801     | TwoDayShift | 08:00:00  | 08:00:00 | 2            |
      | 802     | NormalShift | 08:00:00  | 17:00:00 | 0            |
    When I provide the following 3 cycle entries:
      | DayInCycle | DayOfWeek | ShiftId |
      | 1          | 1         | <D1>    |
      | 2          | 2         | <D2>    |
      | 3          | 3         | <D3>    |
    And I save the group
    Then the system should <Outcome>

    Examples:
      | D1   | D2   | D3   | Outcome                                        |
      | 801  | null | 802  | save the group successfully                    |
      | 802  | null | 802  | fail with business error "NullShiftNotAllowed" |
      | null | 802  | 802  | fail with business error "NullShiftNotAllowed" |
      | 801  | 802  | null | fail with business error "NullShiftNotAllowed" |


  Scenario: Creating a group fails when a null shift is used outside the allowed position
    Given I am creating a new group with "CycleLength" set to 3
    And the following shifts exist:
      | ShiftId | Title        | StartTime | EndTime  | DurationDays |
      | 701     | NormalShift  | 08:00:00  | 17:00:00 | 0            |
      | 702     | HolidayShift | 00:00:00  | 00:00:00 | 0            |
    When I provide the following 3 cycle entries:
      | DayInCycle | DayOfWeek | ShiftId |
      | 1          | 1         | 701     |
      | 2          | 2         | null    |
      | 3          | 3         | 701     |
    And I save the group
    Then the operation should fail with business error "NullShiftNotAllowed"
    And the validation message should indicate "Use HolidayShift instead of null for off days"
    And the group should not be saved


  Scenario: Creating a group fails when a shift is assigned on day 2 of a 2-day shift
    Given I am creating a new group with "CycleLength" set to 3
    And the following shifts exist:
      | ShiftId | Title       | StartTime | EndTime  | DurationDays |
      | 301     | TwoDayShift | 08:00:00  | 08:00:00 | 2            |
      | 302     | DayShift    | 09:00:00  | 17:00:00 | 0            |
    When I provide the following cycle entries:
      | DayInCycle | DayOfWeek | ShiftId |
      | 1          | 1         | 301     |
      | 2          | 2         | 302     |
      | 3          | 3         | 302     |
    And I save the group
    Then the operation should fail with business error "ShiftOverlap"
    And the group should not be saved

  Scenario: Prevent saving when a shift on the last cycle day overlaps the first day of the next cycle
    Given I am creating a new group with "CycleLength" set to 3
    And the following shifts exist:
      | ShiftId | Title          | StartTime | EndTime  | DurationDays |
      | 901     | TwoDayShift    | 08:00:00  | 08:00:00 | 2            |
      | 902     | NormalDayShift | 09:00:00  | 17:00:00 | 0            |
    When I provide the following cycle entries:
      | DayInCycle | DayOfWeek | ShiftId |
      | 1          | 1         | 902     |
      | 2          | 2         | 902     |
      | 3          | 3         | 901     |
    And I save the group
    Then the operation should fail with business error "ShiftOverlapAcrossCycleBoundary"
    And the validation message should indicate "Last day shift overlaps day 1 of next cycle"
    And the group should not be saved

  Scenario Outline: Prevent saving when cycle entries do not match CycleLength
    Given I am creating a new group with "CycleLength" set to 3
    When I provide <provided_count> cycle entries
    And I save the group
    Then the group should not be saved
    And I should see an error "Cycle entries count must equal CycleLength"

    Examples:
      | provided_count | Reason            |
      | 2              | Fewer than length |
      | 4              | More than length  |

  Scenario: Prevent saving when DayInCycle is duplicated
    Given I am creating a new group with "CycleLength" set to 3
    When I provide the following cycle entries:
      | DayInCycle | DayOfWeek | ShiftId |
      | 1          | 1         | 101     |
      | 2          | 2         | 101     |
      | 2          | 3         | 101     |
    And I save the group
    Then the operation should fail with business error "DuplicateDayInCycle"
    And the group should not be saved

  Scenario: Prevent saving when a DayInCycle is missing
    Given I am creating a new group with "CycleLength" set to 3
    When I provide the following cycle entries:
      | DayInCycle | DayOfWeek | ShiftId |
      | 1          | 1         | 101     |
      | 3          | 3         | 101     |
      | 3          | 4         | 101     |
    And I save the group
    Then the operation should fail with business error "MissingDayInCycle"
    And the validation message should indicate "DayInCycle values must cover 1..CycleLength exactly once"
    And the group should not be saved

  Scenario Outline: Prevent saving when DayInCycle is out of range
    Given I am creating a new group with "CycleLength" set to 3
    When I provide the following cycle entries:
      | DayInCycle | DayOfWeek | ShiftId |
      | <BadDay>   | 1         | 101     |
      | 2          | 2         | 101     |
      | 3          | 3         | 101     |
    And I save the group
    Then the operation should fail with business error "DayInCycleOutOfRange"
    And the group should not be saved

    Examples:
      | BadDay |
      | 0      |
      | 4      |

  Scenario: Prevent saving when a cycle entry references a non-existent shift
    Given I am creating a new group with "CycleLength" set to 3
    And no shift exists with id "9999"
    When I provide the following cycle entries:
      | DayInCycle | DayOfWeek | ShiftId |
      | 1          | 1         | 101     |
      | 2          | 2         | 9999    |
      | 3          | 3         | 101     |
    And I save the group
    Then the operation should fail with business error "ShiftNotFound"
    And the validation message should indicate "ShiftId 9999 does not exist"
    And the group should not be saved