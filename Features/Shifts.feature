@first
Feature: shift

Scenario: adding shift by admin
Given in the shift page
And role is admin
When i click button create
Then i see the field to input

Scenario: refuse the duplicate the shift
Given if the shifts is exist
When fill the inputs
And click the create button
Then reject the created shifts
And show notify that is duplicated


Scenario: delete shift
Given the shift is exit
When i click the delete button
Then the shift remove 
And notify the delete 
And update the list shift


Scenario:Edit shift
Given if the shift exsit
When i click Edit
Then the information is show
And i change the field
And click save 
And show the message that is edited



Scenario: Search the shift
Given the list of shift
When i search the exist shift
And click the search
Then show the found shift


Scenario: Shift one day
Given 
When
Then



Scenario: Shift two day
Given
When
Then


