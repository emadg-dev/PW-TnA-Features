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
