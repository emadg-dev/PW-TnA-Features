Feature: position management

Background:
    Given I am logged in as admin
    And the position page is open

Scenario:Search position by keyword
    When the user enters keyword in the search box
    Then the positions list should be filtered 
    And  show the search position

Scenario: Prevent saving without required fields
    Given the create modal is open 
    When the user clicks save without title or code
    Then an error message should be shown
    And the position should not be saved

Scenario: validate title length
    Given the create modal is open
    When the user enters a title shorter than 3 or longer than 50 characters
    And clicks save
    Then an error message should be shown


Scenario: export positions to Excel
    When the user clicks export to Excel
    Then an Excel file should be downloaded