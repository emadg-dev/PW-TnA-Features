Feature: WageCode 2 Approval Logic

  Background:
    Given "OvertimeWithoutApprovalBefore" is "00:00:00" (No auto-approval)
    And the shift starts at "08:00:00"

  Scenario: Work before shift with WageCode 2
    Given a transaction at "07:00:00" has WageCodeId "2"
    And the WageCode duration is "01:00:00"
    When the "Before" overtime is calculated
    Then the "WageCode2Duration" for the segment should be "01:00:00"
    And the "OvertimeWithPermit" should be "01:00:00"
    And the "OvertimeWithoutPermit" should be "00:00:00"

  Scenario: WageCode 2 duration capping
    Given a transaction at "07:00:00" has WageCodeId "2"
    And the WageCode duration is "00:30:00" (Only part of the work is coded)
    And the actual work duration before shift is "01:00:00"
    When the policy is applied
    Then the segment "OvertimeWithPermit" should be "00:30:00"
    And "OvertimeWithoutPermit" should be "00:30:00"