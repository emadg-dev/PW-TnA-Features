@workTime @workSummary
Feature: Work time row building
  As the system
  I want to build a WorkTimeRowDto for a given date
  So that work summaries show holiday/ramadan, group/shift, wage codes, overtime, and transactions consistently

  Scenario: Build a work time row with full inputs
    Given the date is "1404-05-12"
    And CalendarPerGroup exists for GroupId 10 with IsHoliday 1
    And group 10 exists with Title "RnD"
    And the single day shift is:
      | ShiftId | Title    | StartTime | EndTime   | DurationDays |
      | 101     | Morning  | 08:00:00  | 17:00:00  | 0            |
    And HolidayCalendar exists with IsRamadan true
    And wage codes exist:
      | WageCodeId | Title        | Type   |
      | 5          | Mission Pay  | Mission|
    And DailyLeaveOrMission exists on "1404-05-12" with WageCodeId 5
    And overtime for "1404-05-12" is:
      | ApprovedMinutes |
      | 120             |
    And time transactions exist for "1404-05-12":
      | Time   | Type |
      | 08:03  | IN   |
      | 16:58  | OUT  |
    When I build the work time row for "1404-05-12"
    Then the attendance id should be 20260210
    And the attendance date should be "1404-05-12"
    And the attendance holiday flag should be 1
    And the attendance IsRamadan should be true
    And the attendance group should be "RnD"
    And the attendance shift should be "Morning"
    And the attendance WageCodeId should be 5
    And the attendance WageCodeTitle should be "Mission Pay"
    And the attendance WageCodeType should be "Mission"
    And the attendance overtime ApprovedMinutes should be 120
    And the attendance should include time transaction items derived from the transactions
    And the attendance DayOfWeek should be the Persian day name for the date

  Scenario: Holiday flag defaults to 0 when CalendarPerGroup is null
    Given the date is "1404-05-12"
    And CalendarPerGroup is null
    And HolidayCalendar exists with IsRamadan false
    And the single day shift is:
      | ShiftId | Title   | StartTime | EndTime   | DurationDays |
      | 101     | Morning | 08:00:00  | 17:00:00  | 0            |
    When I build the work time row for "1404-05-12"
    Then the attendance holiday flag should be 0

  Scenario: Ramadan flag defaults to false when HolidayCalendar is null
    Given the date is "1404-05-12"
    And CalendarPerGroup exists for GroupId 10 with IsHoliday 0
    And group 10 exists with Title "RnD"
    And HolidayCalendar is null
    And the single day shift is:
      | ShiftId | Title   | StartTime | EndTime   | DurationDays |
      | 101     | Morning | 08:00:00  | 17:00:00  | 0            |
    When I build the work time row for "1404-05-12"
    Then the attendance IsRamadan should be false

  Scenario: Wage code fields are empty when there is no leave or mission on the date
    Given the date is "1404-05-12"
    And CalendarPerGroup exists for GroupId 10 with IsHoliday 0
    And group 10 exists with Title "RnD"
    And HolidayCalendar exists with IsRamadan false
    And there is no DailyLeaveOrMission on "1404-05-12"
    When I build the work time row for "1404-05-12"
    Then the attendance WageCodeId should be null
    And the attendance WageCodeTitle should be empty
    And the attendance WageCodeType should be "None"

  Scenario: TimeTransactionItems are built from transactions using wage codes lookup
    Given the date is "1404-05-12"
    And CalendarPerGroup exists for GroupId 10 with IsHoliday 0
    And group 10 exists with Title "RnD"
    And wage codes exist:
      | WageCodeId | Title       | Type   |
      | 9          | Paid Leave  | PaidLeave |
    And time transactions exist for "1404-05-12":
      | Time   | Type | WageCodeId |
      | 08:00  | IN   | 9          |
      | 17:00  | OUT  | 9          |
    When I build the work time row for "1404-05-12"
    Then the attendance should include 2 time transaction items
    And each time transaction item should include wage code details from the wage codes lookup
