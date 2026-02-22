
Feature: System Parameters Management by Year and Month
As an Admin
I want to manage system parameters per Jalali year and month
So that system configurations are stored and applied correctly

Background: 
    Given I am logged in as an admin
    And the system parameters page is opened

Scenario: Load system parameters using saved year and month from localStorage
    Given jalaliYear and jalaliMonth exist in localStorage
    When the page initializes
    Then jalaliYear should be loaded from storage
    And jalaliMonth should be loaded from storage

Scenario: Load current jalaliYear and jalaliMonth if nothing saved
    Given no jalaliYear amd jalaliMonth exist in localStorage
    When the page initializes
    Then currentYear should be set
    And currentMonth should be set

Scenario: Prevent load when year or month is missing
  Given jalaliYear or jalaliMonth is empty
  When loadSystemParameterByYearMonth is called(blur:focus out field)
  Then a warning notification should be shown
  And display message to complete the field                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         


Scenario: Save system parameter successfully
  Given system parameter form is filled
  When user clicks Save
  Then success notification should be shown


Scenario Outline: Validate valid time format
  Given user enters "<time>" in time field
  When validateTime is executed
  Then result should be true

Examples:
  | time   |
  | 00:00  |
  | 23:59  |


Scenario Outline: Validate invalid time format
  Given user enters "<time>" in time field
  When validateTime is executed
  Then result should be false

Examples:
  | time   |
  | 25:00  |
  | 12:60  |
  | 99:99  |



Scenario: Toggle month picker
  When user clicks month selector
  Then month picker should toggle visibility

Scenario: Select month
  Given month picker is visible
  When user selects a month
  Then jalaliMonth should update
  And localStorage should store jalaliMonth
  And system parameters should reload


Scenario: Navigate to previous month
  Given current month is 1
  When user clicks previous month
  Then month should become 12
  And year should decrement
  And system parameters should reload


Scenario: Navigate to next month
  Given current month is 12
  When user clicks next month
  Then month should become 1
  And year should increment
  And system parameters should reload

Scenario: Toggle year picker
  When user clicks year selector
  Then year picker should toggle visibility

Scenario: Select year
  Given year picker is visible
  When user selects a year
  Then jalaliYear should update
  And system parameters should reload

Scenario: Navigate to previous active year
  Given active years list exists
  When user clicks previous year
  Then jalaliYear should move to previous in list
  And system parameters should reload

Scenario: Navigate to next active year
  Given active years list exists
  When user clicks next year
  Then jalaliYear should move to next in list
  And system parameters should reload

Scenario: Only one system parameter should exist per year and month
  Given a system parameter already exists for year X and month Y
  When user saves again for same period
  Then existing record should be updated
  And duplicate record should not be created

