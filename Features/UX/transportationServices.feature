Feature: transportation management

Background:
    Given i am in as an admin
    And the transportation service page is open
Scenario Outline: search transportation service by keyword
    When the user enters "<keyword>" in the search box
    Then the list should displayed services related to "<keyword>"

Examples:
    |Keyword    |
    |Bus        |
    |Airport    |
    |Parking    |
    |Express    |

Scenario Outline: Filter by title and description
    Given advanced filters are visible
    When the user enters "<title>" as title or enters "<description>" as description
    Then the list should match the entered criteria

Examples:
    | title | description   |
    | Bus | shop            |
    | taxi | company        |

Scenario Outline: filter by parking to card reader time range
    Given advanced filters are visible
    When the user set minimum time to "<min>"
    And set maximum time to "<max>"
    Then only service within that time range should be displayed

Examples:
    |min    |max    |
    |0      |5      |
    |5      |10     |
    |10     |30     |

Scenario Outline: Validate required fields when creating transportation service
  Given the create modal is open
  When the user enters "<title>" as Title
  And clicks Save
  Then "<result>" should be displayed

Examples:
  | title   | result                 |
  |         | Error message          |
  | A       | Error message          |
  | train   | Service saved          |

Scenario Outline: update transportation service title
    Given a transportation service with title "<oldTitle>" exists
    When the user update the title to "<newTitle>"
    And clicks Save
    Then the service title should be "<newTitle>"

Examples:
    |oldTitle   |newTitle   |
    |train      |subway     |
    |motor      |taxi       |

Scenario Outline: delete transportation service
    Given a transportation service named "<title>" exists
    When the user deletes the service
    Then the service "<title>" should no longer appear in the list

Examples:
    |title  |
    |train  |
    |subway |

