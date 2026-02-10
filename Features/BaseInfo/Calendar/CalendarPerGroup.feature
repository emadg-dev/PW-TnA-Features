Scenario Outline: Generated shift is derived from (date - cycleStartDay) mod cycleLength
  Given a group "fullTime" exists with cycleStartDay "1404-01-01" and cycleLength 7
  And the group cycle list for group "fullTime" is:
    | dayInCycle | date       | shiftId |
    | 1          | 1404-01-01 | 1       |
    | 2          | 1404-01-02 | 1       |
    | 3          | 1404-01-03 | 1       |
    | 4          | 1404-01-04 | 1       |
    | 5          | 1404-01-05 | 1       |
    | 6          | 1404-01-06 | 1       |
    | 7          | 1404-01-07 | 500     |
  When I create the calendar for group "fullTime" for year "1404"
  Then the calendar day for group "fullTime" on "<date>" should have shiftId "<shiftId>" and dayInCycle "<dayInCycle>"

  Examples:
    | date       | shiftId | dayInCycle |
    | 1404-01-01 | 1       | 1          |
    | 1404-01-07 | 500     | 7          |
    | 1404-01-08 | 1       | 1          |
    | 1404-01-14 | 500     | 7          |
    | 1404-02-01 | 1       | 4          |

Scenario: Calendar is not generated when consecutive cycle shifts overlap
  Given the following shifts exist:
    | ShiftId | Title   | StartTime | EndTime   | DurationDays |
    | 1       | Shift 1 | 22:00:00  | 06:00:00  | 1            |
    | 2       | Shift 2 | 05:00:00  | 13:00:00  | 0            |
  And a group "RND" exists with cycleStartDay "1404-01-01" and cycleLength 3
  And the group cycle list for group "RND" is:
    | DayInCycle | ShiftId |
    | 1          | 1       |
    | 2          | 1       |
    | 3          | 2       |
  When I create the calendar for group "RND" for year "1404"
  Then the operation should fail with business error "ConsecutiveShiftsOverlap"
  And no calendar days should be generated for group "RND" for year "1404"

  
