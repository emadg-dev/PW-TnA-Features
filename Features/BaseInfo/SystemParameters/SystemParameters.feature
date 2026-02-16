Feature: System parameters load and save
    As a user
    I want to view system parameters for a selected Jalali year/month
    So that I see the effective Fixed, Yearly and Monthly settings and can update them

    Background:
        Given the tenant is "Default"

    # LOAD SYSTEM PARAMETERS
    Scenario: Load aggregated parameters for a selected month using latest Monthly <= target, latest Yearly <= target year, and Fixed

        Given system parameters exist:
            | PeriodType | JalaliYear | JalaliMonth | ConfigJsonStatus |
            | Fixed      | null       | null        | ValidFixedA      |
            | Yearly     | 1403       | null        | ValidYearlyY1403 |
            | Yearly     | 1404       | null        | ValidYearlyY1404 |
            | Monthly    | 1404       | 02          | ValidMonthlyM02  |
            | Monthly    | 1404       | 06          | ValidMonthlyM06  |
        When I request system parameters for Jalali year 1404 and month 09
        Then the result JalaliYear should be 1404
        And the result JalaliMonth should be 09
        And the result Fixed config should come from the Fixed record
        And the result Yearly config should come from the Yearly record for year 1404
        And the result Monthly config should come from the Monthly record for 1404-06

    Scenario: Load monthly parameters returns empty Monthly config when no monthly record exists at or before the requested month
        Given system parameters exist:
            | PeriodType | JalaliYear | JalaliMonth | ConfigJsonStatus |
            | Fixed      | null       | null        | ValidFixedA      |
            | Yearly     | 1404       | null        | ValidYearlyY1404 |
            | Monthly    | 1404       | 10          | ValidMonthlyM10  |
        When I request system parameters for Jalali year 1404 and month 09
        Then the result Monthly config should be empty
        And the result Yearly config should come from the Yearly record for year 1404
        And the result Fixed config should come from the Fixed record

    Scenario: Load yearly parameters returns empty Yearly config when no yearly record exists at or before the requested year
        Given system parameters exist:
            | PeriodType | JalaliYear | JalaliMonth | ConfigJsonStatus |
            | Fixed      | null       | null        | ValidFixedA      |
            | Yearly     | 1405       | null        | ValidYearlyY1405 |
            | Monthly    | 1404       | 06          | ValidMonthlyM06  |
        When I request system parameters for Jalali year 1404 and month 09
        Then the result Yearly config should be empty
        And the result Monthly config should come from the Monthly record for 1404-06
        And the result Fixed config should come from the Fixed record

    Scenario: Load fixed parameters returns empty Fixed config when no fixed record exists
        Given no Fixed system parameter exists
        And system parameters exist:
            | PeriodType | JalaliYear | JalaliMonth | ConfigJsonStatus |
            | Yearly     | 1404       | null        | ValidYearlyY1404 |
            | Monthly    | 1404       | 06          | ValidMonthlyM06  |
        When I request system parameters for Jalali year 1404 and month 09
        Then the result Fixed config should be empty

    Scenario: Invalid ConfigJson returns empty config instead of failing
        Given system parameters exist:
            | PeriodType | JalaliYear | JalaliMonth | ConfigJsonStatus |
            | Fixed      | null       | null        | InvalidJson      |
            | Yearly     | 1404       | null        | InvalidJson      |
            | Monthly    | 1404       | 06          | InvalidJson      |
        When I request system parameters for Jalali year 1404 and month 09
        Then the result Fixed config should be empty
        And the result Yearly config should be empty
        And the result Monthly config should be empty

    # UPDATE SYSTEM PARAMETERS

    Scenario: Update creates Monthly and Yearly records when exact records do not exist
        Given no Monthly system parameter exists for 1404-09
        And no Yearly system parameter exists for 1404
        And a Fixed system parameter exists
        When I update system parameters for Jalali year 1404 and month 09 with:
            | ConfigType | ValueSet |
            | Fixed      | FixedB   |
            | Yearly     | YearlyB  |
            | Monthly    | MonthlyB |
        Then a Monthly system parameter should be created for 1404-09
        And a Yearly system parameter should be created for 1404
        And the Fixed system parameter should be updated
        And each saved record should contain only its own config section:
            | PeriodType | MustHaveConfig | MustHaveNullConfigs |
            | Fixed      | Fixed          | Monthly,Yearly      |
            | Yearly     | Yearly         | Fixed,Monthly       |
            | Monthly    | Monthly        | Fixed,Yearly        |

    Scenario: Update modifies Monthly and Yearly records when exact records already exist
        Given system parameters exist:
            | PeriodType | JalaliYear | JalaliMonth | ConfigJsonStatus |
            | Fixed      | null       | null        | ValidFixedA      |
            | Yearly     | 1404       | null        | ValidYearlyY1404 |
            | Monthly    | 1404       | 09          | ValidMonthlyM09  |
        When I update system parameters for Jalali year 1404 and month 09 with:
            | ConfigType | ValueSet |
            | Fixed      | FixedB   |
            | Yearly     | YearlyB  |
            | Monthly    | MonthlyB |
        Then the Monthly system parameter for 1404-09 should be updated
        And the Yearly system parameter for 1404 should be updated
        And the Fixed system parameter should be updated
        And each saved record should contain only its own config section:
            | PeriodType | MustHaveConfig | MustHaveNullConfigs |
            | Fixed      | Fixed          | Monthly,Yearly      |
            | Yearly     | Yearly         | Fixed,Monthly       |
            | Monthly    | Monthly        | Fixed,Yearly        |

    Scenario: Update always writes to the exact Monthly record for the selected year and month
        Given system parameters exist:
            | PeriodType | JalaliYear | JalaliMonth | ConfigJsonStatus |
            | Monthly    | 1404       | 06          | ValidMonthlyM06  |
        When I update system parameters for Jalali year 1404 and month 09 with Monthly "MonthlyB"
        Then the Monthly system parameter for 1404-09 should exist
        And the Monthly system parameter for 1404-06 should remain unchanged

