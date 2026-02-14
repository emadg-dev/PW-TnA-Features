Feature: Calculate late arrival time
  As a time attendance system
  I want to calculate employee late arrival time
  So that allowed delays, personal forgiveness, holidays and hourly leaves are respected
Background:
  Given time transactions are sorted by date and time
  And time transactions are always paired as Entry and Exit
  And WageCodeId = 0 means normal presence
  And WageCodeId != 0 means hourly leave, mission or other justified absence
Scenario: Calculate late arrival when delay exceeds allowed delay
  Given an employee has the following shift:
    | StartTime | EndTime | AllowedDelay |
    | 07:00     | 15:00   | 00:25        |

  And the employee has the following personal settings:
    | MaxDelayPerDay |
    | 00:04          |

  And the employee has the following time transactions:
    | Type  | Time  | WageCodeId |
    | Entry | 03:00 | 0          |
    | Exit  | 03:30 | 0          |
    | Entry | 05:00 | 0          |
    | Exit  | 06:03 | 0          |
    | Entry | 07:53 | 0          |
    | Exit  | 13:00 | 0          |

  When late arrival is calculated

  Then the initial delay should be 00:53
  And the final late arrival time should be 00:49
Scenario: Late arrival is zero when delay is within allowed delay
  Given an employee has the following shift:
    | StartTime | EndTime | AllowedDelay |
    | 07:00     | 15:00   | 00:40        |

  And the employee has the following personal settings:
    | MaxDelayPerDay |
    | 00:04          |

  And the employee has the following time transactions:
    | Type  | Time  | WageCodeId |
    | Entry | 07:53 | 0          |
    | Exit  | 13:00 | 0          |

  When late arrival is calculated

  Then the late arrival time should be 00:00
Scenario: Reduce late arrival by hourly leave duration
  Given an employee has the following shift:
    | StartTime | EndTime | AllowedDelay |
    | 07:00     | 15:00   | 00:40        |

  And the employee has the following personal settings:
    | MaxDelayPerDay |
    | 00:04          |

  And the employee has the following hourly leaves:
    | From  | To    | Duration |
    | 07:00 | 07:37 | 00:37    |

  And the employee has the following time transactions:
    | Type  | Time  | WageCodeId |
    | Entry | 07:53 | 0          |
    | Exit  | 13:00 | 0          |

  When late arrival is calculated

  Then the late arrival time should be 00:00
Scenario: Late arrival is zero on official holiday
  Given the day is an official holiday
  And holiday is effective for the group

  And an employee has the following shift:
    | StartTime | EndTime | AllowedDelay |
    | 07:00     | 15:00   | 00:25        |

  And the employee has the following time transactions:
    | Type  | Time  | WageCodeId |
    | Entry | 08:30 | 0          |
    | Exit  | 15:00 | 0          |

  When late arrival is calculated

  Then the late arrival time should be 00:00
Scenario: Reduce late arrival by transportation service time
  Given an employee uses a transportation service with parking allowance:
    | ParkingToCardReaderTime |
    | 00:10                   |

  And the employee has the following shift:
    | StartTime | EndTime | AllowedDelay |
    | 07:00     | 15:00   | 00:05        |

  And the employee has the following time transactions:
    | Type  | Time  | WageCodeId |
    | Entry | 07:20 | 0          |
    | Exit  | 15:00 | 0          |

  When late arrival is calculated

  Then the late arrival time should be 00:05
Scenario: Late arrival is zero when reductions exceed delay
  Given an employee has the following shift:
    | StartTime | EndTime | AllowedDelay |
    | 07:00     | 15:00   | 00:10        |

  And the employee has the following personal settings:
    | MaxDelayPerDay |
    | 00:20          |

  And the employee has the following time transactions:
    | Type  | Time  | WageCodeId |
    | Entry | 07:25 | 0          |
    | Exit  | 15:00 | 0          |

  When late arrival is calculated

  Then the late arrival time should be 00:00
