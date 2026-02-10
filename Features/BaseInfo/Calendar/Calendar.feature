Feature: Calendar management

    Background:
        Given I am logged in as a user with "Calendar.YearActivation" permission
        And the tenant is "Default"

    Scenario: Activate a year successfully
        Given the year "1404" is not active
        When I activate the year "1404"
        Then holiday calendar entries should be generated for year "1404" including:
            | date       | isHoliday | isRamadan |
            | 1404-01-01 | 1         | 0         |
            | 1404-01-02 | 1         | 0         |
            | 1404-01-03 | 1         | 0         |
            | 1404-01-04 | 1         | 0         |
        And the year "1404" should be marked as active

    Scenario: Activating an already active year is rejected
        Given the year "1404" is active
        When I Activate the year "1404"
        Then the operation should fail with business error "YearAlreadyActivated"
        And the year activation state for "1404" should remain active
        And holiday calendar entries for year "1404" should not be regenerated

    Scenario: Check if an active year is reported as active
        Given at least a holiday calendar entry exists for year "1404"
        When I check if the year "1404" is active
        Then the result should indicate that year "1404" is active

    Scenario: Check if an inactive year is reported as inactive
        Given no holiday calendar entries exist for year "1404"
        When I check if the year "1404" is active
        Then the result should indicate that year "1404" is inactive

    Scenario: Prevent activating a year when the previous year is inactive
        Given the year "1403" is inactive
        And the year "1404" is not active
        When I activate the year "1404"
        Then the operation should fail with business error "PreviousYearNotActive"
        And the year "1404" should remain inactive
        And no holiday calendar entries should be generated for year "1404"

    

