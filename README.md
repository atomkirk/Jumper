# Jumper

Small extension to Date for 95% of use cases.

### Description

The native Date API for Swift/Cocoa is tedious and clunky. With years of
experience working with these APIs, I've distilled 95% of use cases to just a
handful of methods added to Date. The methods are short and easy to remember
and the parameters are enums so you get auto completion for possible values.


### Global settings

Jumper uses the `Calendar.current` calendar by default. You can assign a new
calendar to `Jumper.calendar = Calendar(identifier: .gregorian)`


If you change any of the following values on `Jumper.calendar` they will be used
in calculations:

- locale
- time zone
- first day of week
- week numbering system

### Creating Dates

    Date(ISOString: "2018-02-01T03:04:01")
    Date(string: "2018-02-01" format: "YYYY-MM-dd")
    Date([.Year: 2015])

### Moving

    date.change([.day: 4]) // 2018-02-04

    date.move([.months: 3]) // 2018-05-04

    date.clamp(to: .end, of: .month, -1) // 2018-02-29 23:59:59

### Measuring

    date.what(.day, of: .year) // 234

    date.diff(.years, .since, date2) // 20

    date.count(.days, in: .month, +1) // 31

### Comparing

    date.within(.Month, date2) // true/false

### Formatting

    date.string("YYYY-MM-dd") //=> "Jun 03 2015"

    NSDateFormatter.symbols(.weekday, .veryShort) // ["S", "M", "T", "W", "T", "F", "S"]