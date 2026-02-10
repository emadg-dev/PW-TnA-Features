Feature: Employee Early Leave Calculation
    This feature calculates the total early leave time for an employee based on their
    shift schedule and physical clock-out times, considering any applicable forgiveness rules.

    @EarlyLeaveForgiveness
    Scenario Outline: Early leave is either forgiven or reduced based on forgiveness rules
        Given a shift that ends at "17:00:00"
        And the employee's daily forgiveness for early leave is <MaxHurryPerDay> minutes
        And the shift's allowed early departure is <AllowedEarlyDeparture> minutes
        And the system's parking delay is <ParkingDelay> minutes
        And the employee's last physical exit is at "<LastExit>"
        When the early leave is calculated
        Then the resulting `EarlyLeaveTime` should be <FinalEarlyLeave> minutes

        Examples:
            | Description                                  | MaxHurryPerDay | AllowedEarlyDeparture | ParkingDelay | LastExit   | FinalEarlyLeave |
            | Nullified: Leave is less than MaxHurryPerDay | 10             | 5                     | 8            | "16:51:00" | 0               |
            | Nullified: Leave is less than ParkingDelay   | 3              | 2                     | 8            | "16:53:00" | 0               |
            | Reduced: Leave is greater than all values    | 5              | 6                     | 8            | "16:45:00" | 10              |

    @OverlappingLeave
    Scenario Outline: Early leave calculation with an overlapping approved hourly leave
        # Calculation: FinalEarlyLeave = (Initial Early Leave - ApprovedLeave) - Forgiveness
        Given a shift that ends at "17:00:00"
        And the employee's daily forgiveness for early leave is 5 minutes
        And the employee's last physical exit is at "<LastExit>"
        And the employee has an approved hourly leave of <ApprovedLeave> minutes ending at "17:00:00"
        When the early leave is calculated
        Then the resulting `EarlyLeaveTime` should be <FinalEarlyLeave> minutes

        Examples:
            | Description                      | LastExit   | ApprovedLeave | FinalEarlyLeave |
            | 30 min approved leave            | "16:00:00" | 30            | 25              |
            | 15 min approved leave            | "16:30:00" | 15            | 10              |
            | Leave equals initial early leave | "16:40:00" | 20            | 0               |

    @MultiDayShift
    Scenario: Calculation for a Multi-Day Shift
        This scenario addresses a shift that spans more than one day, where the employee leaves on the first day.
        Given a shift that starts at "08:00:00" on Day 1 and ends at "08:30:00" on Day 2
        And the employee's daily forgiveness for early leave is 3 minutes
        And the shift's allowed early departure is 0 minutes
        And the system's parking delay is 5 minutes
        And the employee's last physical exit on Day 1 is at "15:00:00"
        And the employee has no clock transactions on Day 2
        And there are no approved leaves between "15:00:00" on Day 1 and "08:30:00" on Day 2
        When the early leave is calculated
        Then the resulting `EarlyLeaveTime` should be 17 hours and 27 minutes.

    @LastTransactionIsEntry
    Scenario: No early leave if the last transaction before shift end is an entry
        An employee cannot have early leave if they are still clocked in.
        Given a shift that ends at "17:00:00"
        And the employee's transaction pairs are:
            | TransactionType | Time       |
            | In              | "08:55:00" |
            | Out             | "12:30:00" |
            | In              | "13:15:00" |
            | Out             | "16:50:00" |
            | In              | "16:55:00" |
        When the early leave is calculated
        Then the resulting `EarlyLeaveTime` should be 0 minutes because the last transaction is an entry.
