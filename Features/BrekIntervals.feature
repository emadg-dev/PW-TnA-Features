Feature: BreakIntervals Validation 

  # VLIDATE BREAK ON SHIFT
  Scenario Outline: Validate break intervals for shifts with various duration days
    Given a shift is defined as:
      | Field        | Value         |
      | StartTime    | <shift_start> |
      | EndTime      | <shift_end>   |
      | DurationDays | <duration>    |

    When I attempt to add a break with:
      | Field     | Value   |
      | StartTime | <b_st>  |
      | EndTime   | <b_et>  |
      | StartDay  | <s_day> |
      | EndDay    | <e_day> |
    Then the break addition should <outcome>
    And I should receive the message "<message>"

    Examples:
      | shift_start | shift_end | duration | b_st     | b_et     | s_day | e_day | outcome | message                   |
      | 09:00:00    | 17:00:00  | 0        | 12:00:00 | 12:30:00 | 0     | 0     | succeed | Saved successfully        |
      | 09:00:00    | 17:00:00  | 0        | 08:30:00 | 09:15:00 | 0     | 0     | fail    | Break starts before shift |
      | 09:00:00    | 17:00:00  | 0        | 16:30:00 | 17:30:00 | 0     | 0     | fail    | Break ends after shift    |
      | 09:00:00    | 17:00:00  | 0        | 12:00:00 | 13:00:00 | 0     | 1     | fail    | Invalid break day range   |
      | 22:00:00    | 06:00:00  | 1        | 23:00:00 | 00:00:00 | 0     | 1     | succeed | Saved successfully        |
      | 22:00:00    | 06:00:00  | 1        | 01:00:00 | 02:00:00 | 1     | 1     | succeed | Saved successfully        |
      | 22:00:00    | 06:00:00  | 1        | 21:00:00 | 22:30:00 | 0     | 0     | fail    | Break starts before shift |
      | 22:00:00    | 06:00:00  | 1        | 05:30:00 | 06:30:00 | 1     | 1     | fail    | Break ends after shift    |
      | 08:00:00    | 18:00:00  | 2        | 10:00:00 | 10:30:00 | 0     | 0     | succeed | Saved successfully        |
      | 08:00:00    | 18:00:00  | 2        | 14:00:00 | 14:30:00 | 1     | 1     | succeed | Saved successfully        |
      | 08:00:00    | 18:00:00  | 2        | 17:30:00 | 18:30:00 | 2     | 2     | fail    | Break ends after shift    |
      | 08:00:00    | 18:00:00  | 2        | 07:30:00 | 08:15:00 | 0     | 0     | fail    | Break starts before shift |
      | 08:00:00    | 18:00:00  | 2        | 11:00:00 | 12:00:00 | 2     | 3     | fail    | Invalid break day range   |

  # VALIDATE BREAK DURATION
  Scenario Outline: Validate break duration consistency
    When I define a break with:
      | Field     | Value      |
      | StartTime | 12:00:00   |
      | EndTime   | 13:00:00   |
      | StartDay  | 0          |
      | EndDay    | 0          |
      | Duration  | <duration> |
    Then the break addition should <outcome>
    And I should receive the message "<message>"

    Examples:
      | duration | outcome | message                                 |
      | 01:00:00 | succeed | Saved successfully                      |
      | 01:30:00 | fail    | Duration exceeds interval length        |
      | 00:45:00 | fail    | Duration does not match interval length |


  Scenario Outline: Validate break overlap logic
    Given a shift has an existing break from "23:00" to "01:00" (StartDay 0, EndDay 1)
    When I attempt to add another break from "<b_st>" to "<b_et>" (StartDay <s_d>, EndDay <e_d>)
    Then the break addition should <outcome>
    And I should receive the message "<message>"

    Examples:
      | b_st     | b_et     | s_d | e_d | outcome | message                        |
      | 00:00:00 | 00:30:00 | 1   | 1   | fail    | Break intervals cannot overlap |
      | 23:30:00 | 00:30:00 | 0   | 1   | fail    | Break intervals cannot overlap |
      | 22:30:00 | 23:30:00 | 0   | 0   | fail    | Break intervals cannot overlap |
      | 22:00:00 | 02:00:00 | 0   | 1   | fail    | Break intervals cannot overlap |
      | 01:00:00 | 02:00:00 | 1   | 1   | succeed | Saved successfully             |
      | 22:00:00 | 23:00:00 | 0   | 0   | succeed | Saved successfully             |

