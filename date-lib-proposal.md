# Global settings

- locale
- time zone
- first day of week
- week numbering system

# Creating Dates

    Date(ISOString: String)
    Date(string: String format: String)
    Date([.Year: 2015])
    Date(components: NSDateComponents)

# Moving

    change([.Day: 4])

    move([.Month: 3])

    clamp(.Start, .Month, -1)

    inTimeZone("MST")

# Measuring

    what(.Day, of: .Year)

    diff(.Years, .Since, date)

    count(.Days, in: .Month, +1)

# Comparing

    occurs(.OnOrBefore, date)

    within(.Month, date)

    between(date, date)

# Formatting

    string([.Month: .Short, .Day: .Long, .Year: .Long]) //=> "Jun 03 2015"

    NSDateFormatter.symbols(.Weekday, .Short)




- creating (date)
- inspecting
- moving (date)
  - to boundaries
  - by units
- measuring (value)
- comparing (bool)
- formatting
