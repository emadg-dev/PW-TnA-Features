@shifts
Feature: Shift Management

Scenario: Admin opens create shift form
  Given I am on the shift page
  And I have admin role
  When I click the create shift button
  Then I should see the shift input fields


Scenario: Admin creates a new shift
  Given I am on the create shift page
  And I have admin role
  When I fill in valid shift information
  And I click the save button
  Then the shift should be created successfully
  And I should see a success notification


Scenario: Prevent creating a duplicate shift
  Given a shift already exists
  When I fill in the shift inputs with valid data
  And I click the create button
  Then the shift should not be created
  And I should see a notification that the shift is duplicated

Scenario: Delete a shift
  Given a shift exists
  When I click the delete button
  Then the shift should be removed
  And I should see a delete notification
  And the shift list should be updated

Scenario: Edit a shift
  Given a shift exists
  And the shift information should be displayed
  When I change the shift value fields
  And I click the save button
  Then updated Information saved successfully

Scenario: Search for a shift
  Given a list of shifts exists
  When I search for an existing shift
  And I click the search button
  Then the matching shift should be displayed

Scenario Outline: Prevent saving a shift with invalid data
  Given I am on the <mode> shift page
  And I have admin role
  When I fill in the shift form with invalid data
  And I click the save button
  Then the shift should not be saved
  And I should see validation error messages

Examples:
  | mode   |
  | create |
  | edit   |

@EffectiveDuration
Scenario Outline: Calculate effective shift duration based on start, end and duration days
  Given a shift start time "<Start>"
  And a shift end time "<End>"
  And duration days is "<DurationDays>"
  When the system calculates the effective duration
  Then the effective duration should be "<ExpectedEffective>"
  And the calculation should be "<Validity>"

Examples:
  | Start  | End    | DurationDays | ExpectedEffective | Validity |
  | 08:00  | 16:00  | 0            | 08:00             | valid    |
  | 22:00  | 06:00  | 1            | 08:00             | valid    |
  | 22:00  | 06:00  | 2            | 32:00             | valid    |
  | 10:00  | 08:00  | 0            | 00:00             | invalid  |
  | null   | 08:00  | 0            | 00:00             | invalid  |


@BreakIntervals
Feature: BreakIntervals Management

Scenario: Apply break intervals only to defined shift days
  Given I am on the shift page
  And a shift is defined with the following days:
    | dayType               | startTime | endTime |
    | regular               | 08:00     | 16:00   |
    | thursday regular      | 08:00     | 14:00   |
    | ramadan               | 09:00     | 15:00   |
  And thursday ramadan is not defined for the shift

  When I define a break interval from 12:00 to 13:00
  And I save the shift

  Then the break interval should be applied to:
    | dayType          |
    | regular          |
    | thursday regular |
    | ramadan          |

  And the break interval should not be applied to:
    | dayType              |
    | thursday ramadan     |


Scenario: Break interval outside shift time should not be applied
  Given a regular shift from 08:00 to 16:00
  When I define a break interval from 17:00 to 18:00
  Then the break interval should not be applied

