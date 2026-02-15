Feature: position management

Background:
    Given I am logged in as admin
    And the position page is open

Scenario:view list of positios
    When the page loads
    Then the list of positios should be displayed

Scenario:Search position by keyword
    When the user enters keyword in the search box
    Then the positions list should be filtered 
    And  show the search position

Scenario:Reset filters
    Given filters are applied
    When the user clicks reset
    Then filters should be cleared
    And the full list should reload

Scenario: Open create position modal
    When the user clicks the button "create"
    Then the create modal should open

Scenario: Prevent saving without required fields
    Given the create modal is open 
    When the user clicks save without title or code
    Then an error message should be shown
    And the position should not be saved

Scenario: create position successfully
    Given required fields are valid 
    When the user clicks save
    Then the position should be saved
    And a success notification should be shown
    And the modal should close
    And the list should refresh

Scenario: validate title length
    Given the create modal is open
    When the user enters a title shorter than 3 or longer than 50 characters
    And clicks save
    Then an error message should be shown

Scenario: open edit position modal
    Given a position exists
    When the user clicks edit
    Then the edit modal should open
    And existing data should be loaded

Scenario: save edited position
    Given the edit modal is open
    When the user updates date and clicks save
    Then the changes should be saved.
    And a success notification should be shown

Scenario: delete position
    Given a position exists
    When the user confirms deletion
    Then the position should be deleted.
    And a success notification should be shown
    And the list should refresh


Scenario: export positions to Excel
    When the user clicks export to Excel
    Then an Excel file should be downloaded