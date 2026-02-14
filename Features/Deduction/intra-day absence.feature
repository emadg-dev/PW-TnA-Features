
Feature: Calculate intra-day absence segments
  As a time attendance system
  I want to calculate only real intra-day absence segments
  So that late arrival, early leave and out-of-shift gaps are ignored
Background:
  Given time transactions are sorted by date and time
  And time transactions are always paired as Entry and Exit
  And WageCodeId = 0 means normal presence
  And WageCodeId != 0 means hourly leave, mission or any other justified absence
  And only absence between first entry after shift start
      And last exit before shift end is considered
Scenario: Calculate absence segments between exit and next entry with normal wage code
  Given an employee has the following shift definition:
    | StartTime | EndTime | DurationDays | AllowedDelay | AllowedEarlyDeparture |
    | 07:00     | 15:00   | 0            | 00:25        | 00:00                 |

  And employee has the following daily transactions:
    | Type  | Time  | WageCodeId |
    | Entry | 07:53 | 0          |
    | Exit  | 13:00 | 0          |
    | Entry | 13:41 | 0          |
    | Exit  | 17:59 | 0          |

  When intra-day absence segments are calculated

  Then the following absence segments should be produced:
    | From  | To    | Duration |
    | 13:00 | 13:41 | 00:41    |
Scenario: Ignore absences outside the valid calculation range
  Given an employee has the following shift definition:
    | StartTime | EndTime | DurationDays |
    | 07:00     | 15:00   | 0            |

  And employee has the following daily transactions:
    | Type  | Time  | WageCodeId |
    | Entry | 03:00 | 0          |
    | Exit  | 03:30 | 0          |
    | Entry | 05:00 | 0          |
    | Exit  | 06:03 | 0          |
    | Entry | 07:53 | 0          |
    | Exit  | 13:00 | 0          |
    | Entry | 13:41 | 0          |
    | Exit  | 17:59 | 0          |

  When intra-day absence segments are calculated

  Then only gaps between first entry after shift start
       And last exit before shift end are considered

  And the following absence segments should be produced:
    | From  | To    | Duration |
    | 13:00 | 13:41 | 00:41    |
Scenario: Do not create absence segment when exit has a wage code
  Given an employee has the following shift definition:
    | StartTime | EndTime | DurationDays |
    | 07:00     | 20:00   | 0            |

  And employee has the following daily transactions:
    | Type  | Time  | WageCodeId |
    | Entry | 09:00 | 0          |
    | Exit  | 11:00 | 5          |
    | Entry | 14:00 | 0          |
    | Exit  | 15:07 | 0          |

  When intra-day absence segments are calculated

  Then no absence segment should be created
Scenario: Reduce absence duration by allowed break duration
  Given an employee has the following shift definition:
    | StartTime | EndTime | DurationDays |
    | 07:00     | 15:00   | 0            |

  And the shift has the following break intervals:
    | BreakStart | BreakEnd | Duration |
    | 12:00      | 13:00    | 00:30    |

  And employee has the following daily transactions:
    | Type  | Time  | WageCodeId |
    | Entry | 08:00 | 0          |
    | Exit  | 12:00 | 0          |
    | Entry | 13:30 | 0          |
    | Exit  | 15:00 | 0          |

  When intra-day absence segments are calculated

  Then the following absence segments should be produced:
    | From  | To    | Duration |
    | 12:00 | 13:30 | 01:00    |
Scenario: No absence when gap duration is fully covered by break
  Given an employee has the following shift definition:
    | StartTime | EndTime | DurationDays |
    | 07:00     | 15:00   | 0            |

  And the shift has the following break intervals:
    | BreakStart | BreakEnd | Duration |
    | 12:00      | 13:00    | 01:00    |

  And employee has the following daily transactions:
    | Type  | Time  | WageCodeId |
    | Entry | 08:00 | 0          |
    | Exit  | 12:00 | 0          |
    | Entry | 13:00 | 0          |
    | Exit  | 15:00 | 0          |

  When intra-day absence segments are calculated

  Then no absence segment should be created
Scenario: Calculate absence correctly for multi-day shift
  Given an employee has the following shift definition:
    | StartTime | EndTime | DurationDays |
    | 22:00     | 06:00   | 1            |

  And employee has the following daily transactions:
    | Type  | Date       | Time  | WageCodeId |
    | Entry | 2025-01-01 | 22:10 | 0          |
    | Exit  | 2025-01-02 | 01:00 | 0          |
    | Entry | 2025-01-02 | 02:00 | 0          |
    | Exit  | 2025-01-02 | 06:10 | 0          |

  When intra-day absence segments are calculated

  Then the following absence segments should be produced:
    | From  | To    | Duration |
    | 01:00 | 02:00 | 01:00    |
