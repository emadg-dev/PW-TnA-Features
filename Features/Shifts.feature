@shifts
Feature: Shift Management

Scenario: Admin adds a new shift
  Given I am on the shift page
  And I have admin role
  When I click the create shift button
  Then I should see the shift input fields

Scenario: Prevent creating a duplicate shift
  Given a shift already exists
  When I fill in the shift inputs with duplicate data
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

Scenario: Create a one-day shift
  Given I am on the shift page
  When I create a shift for one day
  Then the one-day shift should be saved successfully

Scenario: Create a two-day shift
  Given I am on the shift page
  When I create a shift for two days
  Then the two-day shift should be saved successfully


@BreakIntervals
Feature: BreakIntervals Management

Scenario: Apply break intervals only to defined shift days
  Given I am on the shift page
  And a shift is defined with the following days:
    | dayType              | startTime | endTime |
    | regular              | 08:00     | 16:00   |
    | thursday regular     | 08:00     | 14:00   |
    | ramadan              | 09:00     | 15:00   |
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

