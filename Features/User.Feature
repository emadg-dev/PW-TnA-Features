Feature: User management
    As an administrator
    I want to create, view, update, and delete users
    So that I can manage system access

    Background:
        Given I am authenticated as an admin
        
    #CREATE
    Scenario: Create a new user successfully
        Given I am on the create user form
        When I create a user with the following details:
            | username | email           | firstName | lastName |
            | ASamani  | ashkan@test.com | Ashkan    | Samani   |
        Then the user should be created successfully
        And the user should appear in the user list

    Scenario Outline: Fail to create user with invalid or duplicate data
        Given I am on the create user form
        When I create a user with the following details:
            | username   | email   | firstName   | lastName   |
            | <username> | <email> | <firstName> | <lastName> |
        Then the user creation should fail
        And I should receive the message "<message>"

        Examples:
            | username | email           | firstName | lastName | message                          |
            | ASamani  | ashkan@test.com | Ashkan    | Samani   | Username or email already exists |
            |          | test@test.com   | John      | Doe      | Username is required             |
            | user1    |                 | Jane      | Doe      | Email is required                |

    #UPDATE
    Scenario: Update user details successfully
        Given I am on the edit user form
            and a user exists with this information:
            | username | email           | firstName | lastName |
            | ASamani  | ashkan@test.com | Ashkan    | Samani   |
        When I update the user with the following details:
            | firstName | lastName |
            | Jonathan  | Doe      |
        Then the user details should be updated successfully
        And the updated user details should display:
            | username | email           | firstName | lastName |
            | ASamani  | ashkan@test.com | Jonathan  | Doe      |

    #DELETE
    Scenario: Delete user successfully
        Given a user exists with username "ASamani"
        When I delete the user
        Then the user should no longer appear in the user list




