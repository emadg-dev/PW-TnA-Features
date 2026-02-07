Feature: Explicit Manual Approval

  Scenario: Manual Total Overtime distribution
    Given the employee has segments:
      | Type    | Duration |
      | Before  | 01:00:00 |
      | After   | 01:00:00 |
    And a manager approved "OvertimeTotalPerDay" of "01:30:00"
    When the policy is applied
    Then the "Before" segment should have "01:00:00" With Permit
    And the "After" segment should have "00:30:00" With Permit
    And the "After" segment should have "00:30:00" Without Permit