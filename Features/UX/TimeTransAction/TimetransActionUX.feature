Feature: Monthly timesheet Management (TimeTransactions)
  The user can view and edit monthly attendance rows (timesheet),
  modify time transactions, wage codes, overtime values, group and shifts,
  and save changes in batch.
  
  Background:
    Given the user is authenticated
    And the timesheet page is opened
    And wage codes are loaded
    And active years list is loaded

  # Load / navigation
  
  Scenario: Load timesheet from localStorage when saved values exist
    Given localStorage contains "jalaliYear", "jalaliMonth", and "employeeId"
    When the page initializes
    Then the system should load the timesheet for that employee, month and year
    And the selected month and year should match the saved values

  Scenario: Load timesheet using current Jalali date when localStorage is empty
    Given localStorage does not contain "jalaliYear" or "jalaliMonth"
    When the page initializes
    Then the system should set jalaliYear to current Jalali year
    And the system should set jalaliMonth to current Jalali month
    And the system should load the timesheet for that employee, month and year

  Scenario: Navigate to previous month without unsaved changes
    Given there are no unsaved changes
    And current jalaliMonth is 5
    When the user clicks previous month
    Then jalaliMonth should become 4
    And the system should load the timesheet for month 4
 
  Scenario: Navigate to previous month across year boundary
    Given there are no unsaved changes
    And current jalaliMonth is 1
    And current jalaliYear is 1404
    When the user clicks previous month
    Then jalaliMonth should become 12
    And jalaliYear should become 1403
    And the system should load the timesheet for month 12 and year 1403

  Scenario: Navigate month with unsaved changes and user chooses to save
    Given there are unsaved changes
    When the user clicks next month
    And the user confirms saving changes
    Then the system should call batch save for modified rows
    And the system should clear the modified rows list
    And the system should load the next month timesheet

  Scenario: Navigate month with unsaved changes and user chooses not to save
    Given there are unsaved changes
    When the user clicks next month
    And the user chooses not to save changes
    Then the system should discard modified rows
    And the system should load the next month timesheet
    
  Scenario: Changing year with unsaved changes and user closes the dialog
    Given there are unsaved changes
    When the user changes the year
    And the user closes the confirmation dialog
    Then the year should not change
    And the timesheet should not reload
    
    
  # Keyboard shortcuts


  Scenario: Open shift modal with Ctrl+F
    When the user presses "Ctrl+F"
    Then the  list shift modal should open

  Scenario: Generate report with Ctrl+K
    Given there are no unsaved changes
    When the user presses "Ctrl+K"
    Then the report view should be shown

  Scenario: Save changes with F2
    Given there are unsaved changes
    When the user presses "F2"
    Then the system should call batch save for modified rows
    
 

  # Editing time transactions within a day

   
  Scenario: Mark a transaction as deleted when time is cleared
    Given a day row has an existing time transaction
    When the user clears the time input for that transaction
    Then the transaction should be marked as deleted
    And the day should be added to the modified rows list

  Scenario: Validate time input rejects invalid time
    Given a day row has a time transaction input
    When the user enters time "29:99"
    Then the time input should be marked invalid
    And saving should be disallowed

 
  Scenario: Add a new time transaction for a day
    Given a day row is in "adding time" mode
    When the user enters new time "08:15"
    And the user confirms add
    Then a new transaction item should be appended to that day
    And the new transaction should have source "Application"
    And the day should be added to the modified rows list
    And the new time input should be cleared

  Scenario: ArrowLeft on a time input starts adding new time
    Given the focus is on a time transaction input
    When the user presses "ArrowLeft"
    Then the day row should enter "adding time" mode
    And focus should move to the new time input

  
  # Context menu for day row (right click on day)
  

  Scenario: Right click on day opens context menu 
    Given a day row is editable
    When the user right clicks on the day row
    Then the context menu should be shown
    And the menu position should not overflow outside the window

  Scenario: Clicking outside closes the context menu
    Given the context menu is visible
    When the user clicks outside the context menu
    Then the context menu should be hidden

  Scenario: Right click does nothing if day has wage code and is not edited by user
    Given a day row has a daily wage code set
    And the day row is not marked as edited by user
    When the user right clicks on the day row
    Then the context menu should not be shown


  Scenario: Saving daily wage code  applies wage code to selected day
    Given the daily wage code  modal is open
    When the user confirms save daily wage code 
    Then the selected day should be marked edited by user
    And the day attendance wageCodeId and wageCodeTitle should be updated
    And the day should be added to modified rows list


  # Context menu for a transaction item (right click on transaction)


  Scenario: Right click on a transaction opens hourly wage codes list
    Given the selected day has a shift with start and end times
    When the user right clicks on a transaction item
    Then the context menu should be shown
    And hourly wage codes list should contain active hourly wage codes
    And if the transaction has no wage code, disallow wage code type 6

  Scenario: Selecting hourly wage code  duration modal when needed
    Given the context menu is open for a transaction
    And the selected wage code is hourly
    And the selected wage code type is not 6
    When the user selects the wage code
    Then the duration modal should open
    And the modal title should include wage code title and selected date

  Scenario: Selecting hourly wage code type 6 sets duration to 00:00 and saves without modal
    Given the context menu is open for a transaction
    And the selected wage code is hourly
    And the selected wage code type is 6
    When the user selects the wage code
    Then the transaction duration should become "00:00"
    And the system should apply wage code to the transaction
    And the system should not show duration modal

  Scenario: Confirm duration applies wage code and duration rules
    Given the duration modal is open
    And the user selects duration type "attendance"
    When the user confirms duration
    Then the transaction wageCodeId and title should be set
    And transaction isDurationAuto should be true
    And the transaction duration should be "00:00:00"
    And the selected day should be added to modified rows list

  Scenario: Confirm duration with "hourly" stores typed duration
    Given the duration modal is open
    And the user selects duration type "hourly"
    And the user enters duration "01:30"
    When the user confirms duration
    Then transaction isDurationAuto should be false
    And the transaction duration should be "01:30:00"
    And the selected day should be added to modified rows list

  Scenario: Reset transaction time restores original values
    Given a transaction time was edited
    When the user chooses "reset time"
    Then the transaction time should revert to its original time
    And the transaction should not be marked deleted

  Scenario: Reset wage code restores original wage code and duration values
    Given a transaction wage code was edited
    When the user chooses "reset wage code"
    Then wageCodeId should revert to original wageCodeId
    And duration should revert to original duration
    And isDurationAuto should revert to original flag

  
  # Overtime editing
 

  Scenario: Editing overtime stores UI value and DTO minutes
    Given a day row has overtime object
    When the user changes overtime field "overtimeBefore" to "02:15"
    Then overtimeBeforeUi should be "02:15"
    And the day should be added to modified rows list

  Scenario: Entering incomplete overtime value results in null minutes
    Given a day row has overtime object
    When the user enters overtime field "overtimeAfter" as "__:__"
    And overtimeAfter  should be null

  Scenario: Total overtime field is disabled when any part field has value
    Given a day row overtimeBeforeUi is "01:00"
    When the day row is rendered
    Then overtimeTotal input should be disabled

  Scenario: Part overtime fields are disabled when total overtime has value
    Given a day row overtimeTotalUi is "03:00"
    When the day row is rendered
    Then overtimeBefore input should be disabled
    And overtimeBetween input should be disabled
    And overtimeAfter input should be disabled

 
  # Group editing
  

  Scenario: Edit group code for a day and auto-assign shift
    Given the user is editing group code in a day row
    When the user enters group code "3" and blurs the input
    And the group code exists in group dropdown list
    Then the day group should be updated to the matched group
    And the system should fetch and set shift for the group and day date
    And the day should be added to modified rows list

  Scenario: Edit group code with no match keeps the entered code
    Given the user is editing group code in a day row
    When the user enters group code "99" and blurs the input
    And there is no matching group in dropdown list
    Then the day group code should remain "99"
    And the day should stay in editing mode

  Scenario: Admin multi-select days and set group code by numeric key
    Given the user is an admin
    And the user selects multiple day rows
    When the user presses numeric key "2"
    Then a selected-days modal/indicator should be shown
    And the group code value should become 2

  Scenario: Admin saves group value to all selected days
    Given the user is an admin
    And multiple day rows are selected
    And groupValue is 2
    When the user confirms save group value
    Then each selected day should update its group to matched group code 2
    And each selected day should fetch and update its shift
    And each selected day should be added to modified rows list

 
  # Report generation
 

  Scenario: Report is built from summary fields and hides zeros
    Given a timesheet summary exists with presenceSum, overtimeSum, deductionSum and others
    When the report is built
    Then report boxes should be created for each section that has rows
    And rows with value "-" or "00:00" should be hidden
    But "کسر کار ساعتی" and "اضافه کار پرداختنی" should remain even if zero

  
  # Saving changes
 

  Scenario: Save changes sends only modified rows with mapped DTO fields
    Given the user edited multiple days
    When the user saves changes
    Then the system should send a WorkTimeSummaryDto containing only modified days
    And each sent day should include group id/title/code if selected
    And timeTransactionItems should exclude deleted items and empty times
    And modified rows list should be cleared after successful save
    And the timesheet should be reloaded for current employee, month and year


Scenario Outline: Navigate month without unsaved changes
  Given there are no unsaved changes
  And current jalaliMonth is <currentMonth>
  And current jalaliYear is <currentYear>
  When the user clicks <direction> month
  Then jalaliMonth should become <expectedMonth>
  And jalaliYear should become <expectedYear>
  And the system should load the timesheet for that month and year

Examples:
  | direction | currentMonth | currentYear | expectedMonth | expectedYear |
  | previous  | 5            | 1404        | 4             | 1404         |
  | previous  | 1            | 1404        | 12            | 1403         |
  | next      | 12           | 1403        | 1             | 1404         |


Scenario Outline: Keyboard shortcuts behavior
  Given the timesheet page is active
  And there are <unsavedState> unsaved changes
  When the user presses "<key>"
  Then <expectedResult>

Examples:
  | key     | unsavedState | expectedResult                              |
  | Ctrl+F | no           | list shift modal should open               |
  | Ctrl+K | no           | report view should be shown                |
  | F2     | yes          | system should call batch save for rows     |


Scenario Outline: Day row context menu availability
  Given a day row has daily wage code <hasWageCode>
  And the day row is <editedState> by user
  When the user right clicks on the day row
  Then the context menu should be <menuState>

Examples:
  | hasWageCode | editedState | menuState |
  | yes         | not edited  | hidden    |
  | yes         | edited      | shown     |
  | no          | edited      | shown     |


Scenario Outline: Selecting hourly wage code behavior
  Given the context menu is open for a transaction
  And the selected wage code is hourly
  And wage code type is <type>
  When the user selects the wage code
  Then <result>

Examples:
  | type | result                                                       |
  | 6    | duration is set to "00:00" and modal is not shown            |
  | 1    | duration modal should open                                   |


Scenario Outline: Overtime field enable and disable rules
  Given a day row overtime state is <state>
  When the day row is rendered
  Then <enabledFields> should be enabled
  And <disabledFields> should be disabled

Examples:
  | state             | enabledFields                                       | disabledFields                                 |
  | totalFilled       | overtimeTotal                                       | overtimeBefore,overtimeBetween,overtimeAfter   |
  | partsFilled       | overtimeBefore,overtimeBetween,overtimeAfter        | overtimeTotal                                  |
