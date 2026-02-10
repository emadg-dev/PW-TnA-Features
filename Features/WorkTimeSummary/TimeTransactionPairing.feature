@workTime @pairing
Feature: Pair time transactions across days
  As the system
  I want to pair and redistribute time transactions across days based on shift windows
  So that each day has complete IN/OUT pairs and transactions are classified relative to shift time

  Background:
    Given a work time summary exists with rows sorted by date after processing

  Scenario: Same-day shift with complete transactions remains unchanged
    Given a work time summary for employee "266" has rows:
      | Date       | GroupIsMultiDayAttendance | ShiftId | ShiftStart | ShiftEnd  | DurationDays | CpgHoliday | CrossDayTolerance |
      | 1404-01-01 | true                      | 101     | 08:00:00   | 17:00:00  | 0            | None      | 00:15:00          |
    And time transactions for date "1404-01-01" are:
      | Id | Time     |
      | 1  | 08:05:00  |
      | 2  | 16:55:00  |
    When I pair time transactions
    Then the paired transactions for date "1404-01-01" should be:
      | Id | Time     | IsExit |
      | 1  | 08:05:00 | false  |
      | 2  | 16:55:00 | true   |
    And the day "1404-01-01" should not have info "MissingTimeTransaction"

  Scenario: Same-day shift with missing exit borrows one transaction from next day when MultiDayAttendance is enabled
    Given a work time summary for employee "266" has rows:
      | Date       | GroupIsMultiDayAttendance | ShiftId | ShiftStart | ShiftEnd  | DurationDays | CpgHoliday | CrossDayTolerance |
      | 1404-01-01 | true                      | 101     | 08:00:00   | 17:00:00  | 0            | None      | 00:15:00          |
      | 1404-01-02 | true                      | 102     | 08:00:00   | 17:00:00  | 0            | None      | 00:15:00          |
    And time transactions for date "1404-01-01" are:
      | Id | Time     |
      | 1  | 08:03:00 |
    And paired time transactions for date "1404-01-02" are:
      | Id | Time     |
      | 2  | 00:30:00 |
      | 3  | 08:10:00 |
      | 4  | 17:05:00 |
    When I pair time transactions
    Then the paired transactions for date "1404-01-01" should include:
      | Id | Time     |
      | 1  | 08:03:00 |
      | 2  | 00:30:00 |
    And the paired transactions for date "1404-01-02" should not include:
      | Id |
      | 2  |
    And the day "1404-01-01" should not have info "MissingTimeTransaction"

  Scenario: Same-day shift with missing exit stays missing when MultiDayAttendance is disabled
    Given a work time summary for employee "266" has rows:
      | Date       | GroupIsMultiDayAttendance | ShiftId | ShiftStart | ShiftEnd  | DurationDays | CpgHoliday | CrossDayTolerance |
      | 1404-01-01 | false                     | 101     | 08:00:00   | 17:00:00  | 0            | None      | 00:15:00          |
      | 1404-01-02 | false                     | 102     | 08:00:00   | 17:00:00  | 0            | None      | 00:15:00          |
    And time transactions for date "1404-01-01" are:
      | Id | Time     |
      | 1  | 08:03:00 |
    And time transactions for date "1404-01-02" are:
      | Id | Time     |
      | 2  | 08:10:00 |
      | 3  | 17:05:00 |
    When I pair time transactions
    Then the day "1404-01-01" should have info "MissingTimeTransaction"

  Scenario: Overnight shift pulls related transactions from the next day into the start day
    Given a work time summary for employee "266" has rows:
      | Date       | GroupIsMultiDayAttendance | ShiftId | ShiftStart | ShiftEnd  | DurationDays | CpgHoliday | CrossDayTolerance |
      | 1404-01-01 | true                      | 201     | 22:00:00   | 06:00:00  | 1            | None      | 00:15:00          |
      | 1404-01-02 | true                      | 202     | 08:00:00   | 17:00:00  | 0            | None      | 00:15:00          |
    And time transactions for date "1404-01-01" are:
      | Id | Time     |
      | 1  | 22:05:00 |
    And time transactions for date "1404-01-02" are:
      | Id | Time     |
      | 2  | 05:55:00 |
      | 3  | 08:10:00 |
      | 4  | 17:00:00 |
    When I pair time transactions
    Then the paired transactions for date "1404-01-01" should include:
      | Id | Time     |
      | 1  | 22:05:00 |
      | 2  | 05:55:00 |
    And the paired transactions for date "1404-01-02" should not include:
      | Id |
      | 2  |
    And the paired transaction "1" should be marked as "InsideShift"
    And the paired transaction "2" should be marked as "InsideShift"

  Scenario: Multi-day shift (2 days) pulls related transactions from both next days into the start day
    Given a work time summary for employee "266" has rows:
      | Date       | GroupIsMultiDayAttendance | ShiftId | ShiftStart | ShiftEnd  | DurationDays | CpgHoliday | CrossDayTolerance |
      | 1404-01-01 | true                      | 301     | 08:00:00   | 08:00:00  | 2            | None      | 00:15:00          |
      | 1404-01-02 | true                      | 401     | 09:00:00   | 17:00:00  | 0            | None      | 00:15:00          |
      | 1404-01-03 | true                      | 402     | 09:00:00   | 17:00:00  | 0            | None      | 00:15:00          |
    And time transactions for date "1404-01-01" are:
      | Id | Time     |
      | 1  | 08:05:00 |
    And time transactions for date "1404-01-02" are:
      | Id | Time     |
      | 2  | 12:00:00 |
    And time transactions for date "1404-01-03" are:
      | Id | Time     |
      | 3  | 07:55:00 |
      | 4  | 09:05:00 |
    When I pair time transactions
    Then the paired transactions for date "1404-01-01" should include:
      | Id | Time     |
      | 1  | 08:05:00 |
      | 2  | 12:00:00 |
      | 3  | 07:55:00 |
    And the paired transactions for date "1404-01-02" should not include:
      | Id |
      | 2  |
    And the paired transactions for date "1404-01-03" should not include:
      | Id |
      | 3  |

  Scenario: Mark a day as MissingTimeTransaction when paired transactions remain odd
    Given a work time summary for employee "266" has rows:
      | Date       | GroupIsMultiDayAttendance | ShiftId | ShiftStart | ShiftEnd  | DurationDays | CpgHoliday | CrossDayTolerance |
      | 1404-01-01 | true                      | 101     | 08:00:00   | 17:00:00  | 0            | None      | 00:15:00          |
    And time transactions for date "1404-01-01" are:
      | Id | Time     |
      | 1  | 08:03:00 |
    When I pair time transactions
    Then the day "1404-01-01" should have info "MissingTimeTransaction"

  Scenario: Classify paired time transactions as BeforeShift, InsideShift, and AfterShift
    Given a work time summary for employee "266" has rows:
      | Date       | GroupIsMultiDayAttendance | ShiftId | ShiftStart | ShiftEnd  | DurationDays | CpgHoliday | CrossDayTolerance |
      | 1404-01-01 | true                      | 101     | 08:00:00   | 17:00:00  | 0            | None      | 00:15:00          |
    And time transactions for date "1404-01-01" are:
      | Id | Time     |
      | 1  | 07:50:00 |
      | 2  | 08:10:00 |
      | 3  | 16:59:00 |
      | 4  | 17:30:00 |
    When I pair time transactions
    Then the paired transaction "1" should be marked as "BeforeShift"
    And the paired transaction "2" should be marked as "InsideShift"
    And the paired transaction "3" should be marked as "InsideShift"
    And the paired transaction "4" should be marked as "AfterShift"
