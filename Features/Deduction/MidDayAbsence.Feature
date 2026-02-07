Feature: Mid-Day Absence Calculation

  Background:
    Given a shift has a lunch break from "12:00:00" to "13:00:00" (Duration: 60m)

  Scenario: Calculate gap minus break overlap
    When an employee exits at "11:50:00" and returns at "13:10:00"
    Then the segment duration should be "01:20:00"
    And the break overlap should be "01:00:00"
    And the "AbsenceBetween" should be "00:20:00"

  Scenario: Absence segment covered by Mission (Auto-duration)
    Given an employee has the following transactions:
      | Type  | Time     | WageCode | Note                           |
      | Exit  | 10:00:00 | Mission  | Duration is 0 in record        |
      | Entry | 11:30:00 | 0        |                                |
    When the mid-day absence is calculated
    Then the "deductedTime" for this segment should be "01:30:00"
    And the "AbsenceBetween" should be "00:00:00"

  Scenario: Break duration limit across multiple segments
    Given a break from "12:00:00" to "13:00:00" (Total 60m)
    When the employee has an absence from "12:00:00" to "12:40:00" (Used 40m)
    And another absence from "12:50:00" to "13:10:00" (Overlap 10m)
    Then the second segment should only subtract "10" minutes of break
    And the "AbsenceBetween" for the second segment should be "00:10:00"