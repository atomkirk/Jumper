//: Playground - noun: a place where people can play

import UIKit

enum DateComponent {
    case Year, Years
    case Month, Months
    case Week, Weeks
    case Day, Days
    case Hour, Hours
    case Minute, Minutes
    case Second, Seconds
}

enum DateBoundary {
    case start, end
}

enum DateTense {
    case since, until
}

class Jumper {
    public static var calendar: Calendar = Calendar.current
    public static var iso8601: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
}

extension Date {
    
    // Date(ISOString: String)
    init?(ISOString: String) {
        if let date = Jumper.iso8601.date(from: ISOString)  {
            self = date
        }
        else {
            return nil
        }
    }
    
    // Date(string: String format: String)
    init?(string: String, format: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        if let date = formatter.date(from: string)  {
            self = date
        }
        else {
            return nil
        }
    }
    
    // Date([.Year: 2015])
    init?(_ comps: [DateComponent: Int]) {
        var components = DateComponents()
        for (comp, value) in comps {
            components.setValue(value, for: Date.toNativeUnits(comp))
        }
        if let date = Jumper.calendar.date(from: components)  {
            self = date
        }
        else {
            return nil
        }
    }
    
    // Date(components: DateComponents)
    init?(components: DateComponents) {
        if let date = Jumper.calendar.date(from: components)  {
            self = date
        }
        else {
            return nil
        }
    }
    
    // change([.Day: 4])
    func change(_ param: [DateComponent: Int]) -> Date {
        var components = Jumper.calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
        for pair in param {
            switch pair {
            case let (.Year, value), let (.Years, value):
                components.year = value
            case let (.Month, value), let (.Months, value):
                components.month = value
            case let (.Week, value), let (.Weeks, value):
                components.weekOfYear = value
            case let (.Day, value), let (.Days, value):
                components.day = value
            case let (.Hour, value), let (.Hours, value):
                components.hour = value
            case let (.Minute, value), let (.Minutes, value):
                components.minute = value
            case let (.Second, value), let (.Seconds, value):
                components.minute = value
            }
        }
        return Jumper.calendar.date(from: components)!
    }
    
    // move([.Month: 3])
    func move(_ param: [DateComponent: Int]) -> Date {
        var components = DateComponents()
        for pair in param {
            switch pair {
            case let (.Year, value), let (.Years, value):
                components.year = value
            case let (.Month, value), let (.Months, value):
                components.month = value
            case let (.Week, value), let (.Weeks, value):
                components.weekOfYear = value
            case let (.Day, value), let (.Days, value):
                components.day = value
            case let (.Hour, value), let (.Hours, value):
                components.hour = value
            case let (.Minute, value), let (.Minutes, value):
                components.minute = value
            case let (.Second, value), let (.Seconds, value):
                components.minute = value
            }
        }
        return Jumper.calendar.date(byAdding: components, to: self)!
    }
    
    // clamp(.Start, .Month, -1)
    func clamp(_ boundary: DateBoundary, _ comp: DateComponent, _ offset: Int = 0) -> Date {
        let date: Date
        if offset != 0 {
            date = move([comp: offset])
        }
        else {
            date = self
        }
        switch boundary {
        case .start:
            let unit = Date.toNativeUnits(comp)
            var interval = TimeInterval(0)
            var startOf = Date()
            Jumper.calendar.dateInterval(of: unit, start: &startOf, interval: &interval, for: date)
            return startOf
        case .end:
            let unit = Date.toNativeUnits(comp)
            var interval = TimeInterval(0)
            var startOf = Date()
            Jumper.calendar.dateInterval(of: unit, start: &startOf, interval: &interval, for: date)
            return startOf.addingTimeInterval(interval - 1)
        }
    }
    
    // what(.Day, of: .Year)
    func what(_ inner: DateComponent, of outer: DateComponent) -> Int {
        return Jumper.calendar.ordinality(of: Date.toNativeUnits(inner), in: Date.toNativeUnits(outer), for: self)!
    }
    
    // diff(.Years, .Since, date)
    func diff(_ unit: DateComponent, _ tense: DateTense, _ target: Date) -> Int {
        let components: DateComponents
        switch tense {
        case .since:
            components = Jumper.calendar.dateComponents([Date.toNativeUnits(unit)], from: target, to: self)
        case .until:
            components = Jumper.calendar.dateComponents([Date.toNativeUnits(unit)], from: self, to: target)
        }
        return components.value(for: Date.toNativeUnits(unit))!
    }
    
    // count(.Days, in: .Month, +1)
    func count(_ unit: DateComponent, in outer: DateComponent, _ offset: Int = 0) -> Int? {
        if let result = Jumper.calendar.range(of: Date.toNativeUnits(unit, outer), in: Date.toNativeUnits(outer), for: self) {
            return result.count
        }
        return nil
    }
    
    func within(_ unit: DateComponent, _ other: Date) -> Bool {
        return Jumper.calendar.isDate(self, equalTo: other, toGranularity: Date.toNativeUnits(unit))
    }
    
    private static func toNativeUnits(_ comp: DateComponent, _ outer: DateComponent? = nil) -> Calendar.Component {
        switch comp {
        case .Year, .Years: return .year
        case .Month, .Months: return .month
        case .Week, .Weeks: return .weekOfYear
        case .Day, .Days: return .day
        case .Hour, .Hours: return .hour
        case .Minute, .Minutes: return .minute
        case .Second, .Seconds: return .second
        }
    }
}

Date(ISOString: "2018-01-23T03:06:46.232Z")!
Date(string: "1986-07-11", format: "yyyy-MM-dd")!
Date([.Year: 2013, .Month: 1, .Day: 15])!
Date(components: DateComponents(calendar: Jumper.calendar, timeZone: nil, era: nil, year: 2001, month: 9, day: 11, hour: 0, minute: nil, second: nil, nanosecond: nil, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil))!

let now = Date()
now.change([.Days: 4, .Minutes: 3])
now.change([.Days: 4, .Minutes: 3])

now.move([.Days: 4])
now.move([.Days: 4, .Minute: 2])

now.clamp(.start, .Day)
now.clamp(.end, .Week)
now.clamp(.end, .Month)
now.clamp(.end, .Month, 1) // end of next month
now.clamp(.end, .Day, -1) // end of yesterday
now.clamp(.end, .Month, -3) // end of the month, 3 months ago
now.clamp(.end, .Week, -3) // end of the week, 3 weeks ago

now.what(.Day, of: .Year)
now.what(.Day, of: .Week)
now.what(.Hour, of: .Month)
now.what(.Minute, of: .Year)

let birth = Date(string: "1986-07-11", format: "yyyy-MM-dd")!
now.diff(.Years, .since, birth)
now.diff(.Seconds, .since, birth)
birth.diff(.Months, .until, now)

//Jumper.calendar.rangeOfUnit(.day, inUnit: .month, forDate: Date())
now.count(.Day, in: .Month)

Jumper.calendar.range(of: .hour, in: .year, for: Date())

let february = Date([.Year: 2018, .Month: 2, .Day: 5])!
now.within(.Month, february)
now.within(.Week, february)

