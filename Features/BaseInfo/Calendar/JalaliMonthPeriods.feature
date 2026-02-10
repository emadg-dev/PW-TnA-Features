@jmonth @calendar @settings
Feature: Custom Jalali month periods
        To compute payroll and attendance consistently
        As a user
        I want each Jalali month to have a configurable start day
        And I want to find which month period a given date belongs to

    Background:
        Given the tenant is "Default"

    Scenario Outline: Compute period start and end for a Jalali month based on MonthStartDay
        Given the MonthStartDay setting is <MonthStartDay>
        When I request the period for Jalali month "<YearMonth>"
        Then the period start date should be "<ExpectedStart>"
        And the period end date should be "<ExpectedEnd>"

        Examples:
            | MonthStartDay | YearMonth | ExpectedStart | ExpectedEnd |
            | 1             | 1404-05   | 1404-05-01    | 1404-05-31  |
            | 10            | 1404-05   | 1404-04-10    | 1404-05-10  |
            | 27            | 1404-05   | 1404-04-27    | 1404-05-27  |

    Scenario Outline: Determine which Jalali month period contains a date
        Given the MonthStartDay setting is <MonthStartDay>
        When I ask which Jalali month period contains date "<Date>"
        Then the result should be Jalali month "<ExpectedYearMonth>"

        Examples:
            | MonthStartDay | Date       | ExpectedYearMonth |
            | 1             | 1404-05-01 | 1404-05           |
            | 1             | 1404-05-31 | 1404-05           |
            | 10            | 1404-04-09 | 1404-04           |
            | 10            | 1404-04-10 | 1404-05           |
            | 10            | 1404-05-10 | 1404-05           |
            | 10            | 1404-05-11 | 1404-06           |
            | 27            | 1404-04-26 | 1404-04           |
            | 27            | 1404-04-27 | 1404-05           |
            | 27            | 1404-05-27 | 1404-05           |
            | 27            | 1404-05-28 | 1404-06           |

    Scenario Outline: Reject MonthStartDay values that are out of allowed range
        When I set MonthStartDay to <Value>
        Then the operation should fail with business error "InvalidMonthStartDay"

        Examples:
            | Value |
            | 0     |
            | -1    |
            | 30    |
            | 31    |
            | 32    |

