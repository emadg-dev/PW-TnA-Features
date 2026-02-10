Feature: Create or Edit Overtime Per Days

  Background:
    Given the overtime per day modal component exists

# Create mode
#initial
  Scenario: Open modal in create mode
    When the user opens the overtime modal without an id
    Then the modal should be active
    And the modal should be visible
    And overtimePerDay.id should be null
    And overtimePerDay.date should be set to start of today
    And overtimeBefore should be empty
    And overtimeBetween should be empty
    And overtimeAfter should be empty
    And overtimeTotal should be empty
    And employee should not be selected

  Scenario: Open modal in edit mode
    Given an overtime record exists
    When the user opens the overtime modal with an id
    Then overtime data should be loaded 
    And employee display name should be shown
    And the modal should be active

  
  # Employee selection
  Scenario: Select employee from lookup modal
    Given the overtime modal is open
    When the user opens employee lookup modal
    And selects an employee
    Then overtimePerDay.employeeId should be set
    And employee display name should be shown

  Scenario: Clear selected employee
    Given an employee is selected
    When the user clears the employee selection
    Then overtimePerDay.employeeId should be null
    And employee display name should be empty

  
  # Date handling
  Scenario: Select date using  date picker
    Given the modal is open
    When the user selects a Shamsi date
    Then DateShamsi should be updated

  Scenario: Clear date manually
    Given a date is selected
    When the user clears the date input
    Then DateShamsi should be null
    And overtimePerDay.date should be null

 
  # Time validation
  Scenario Outline: Enter valid overtime time
    Given the modal is open
    When the user enters "<time>" in "<field>"
    Then the time should be considered valid
    And "<field>" should not appear in invalidTimeFields

    Examples:
      | field             | time    |
      | overtimeBefore    | 02:30   |
      | overtimeBetween   | 24:00   |
      | overtimeAfter     | 05:59   |
      | overtimeTotal     | 20:00  |

  Scenario Outline: Enter invalid overtime time
    Given the modal is open
    When the user enters "<time>" in "<field>"
    Then the time should be considered invalid
    And "<field>" should appear in invalidTimeFields

    Examples:
      | field           | time   |
      | overtimeBefore  | 25:99  |
      | overtimeAfter   | 55:35 |
      | overtimeTotal   | 10:88 |

  Scenario: Incomplete masked time input
    Given the modal is open
    When the user enters "__:__" in a time field
    Then the field should not be marked invalid


  # Save validation
  Scenario: Prevent save without employee
    Given the modal is open
    And no employee is selected
    When the user clicks Save
    Then an error message "پرسنل را انتخاب کنید" should be shown
    And saving should stop

  Scenario: Prevent save when invalid time exists
    Given the modal is open
    And invalid time fields exist
    When the user clicks Save
    Then an error alert with invalid fields list should be shown
    And saving should stop

  # Create / Edit save
  Scenario: Save new overtime successfully
    Given the modal is open in create mode
    And employee is selected
    And all time fields are valid
    When the user clicks Save
    Then success notification should be shown
    And the modal should close



Background:
    Given the overtime per day modal is open

  Scenario: Disable total when overtimeBefore has value
    When the user enters "02:00" in overtimeBefore
    Then overtimeTotal field should be disabled

  Scenario: Disable total when overtimeBetween has value
    When the user enters "03:00" in overtimeBetween
    Then overtimeTotal field should be disabled

  Scenario: Disable total when overtimeAfter has value
    When the user enters "01:30" in overtimeAfter
    Then overtimeTotal field should be disabled

  Scenario: Disable before, between, and after when total has value
    When the user enters "06:00" in overtimeTotal
    Then overtimeBefore field should be disabled
    And overtimeBetween field should be disabled
    And overtimeAfter field should be disabled

  Scenario: Re-enable total when before, between, and after are cleared
    Given overtimeBefore is empty
    And overtimeBetween is empty
    And overtimeAfter is empty
    When the form state is evaluated
    Then overtimeTotal field should be enabled

  Scenario: Re-enable detailed fields when total is cleared
    Given overtimeTotal is empty
    When the form state is evaluated
    Then overtimeBefore field should be enabled
    And overtimeBetween field should be enabled
    And overtimeAfter field should be enabled
