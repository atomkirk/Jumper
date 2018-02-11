//
//  Jumper.swift
//  Jumper
//
//  Created by Adam Kirk on 2/6/18.
//  Copyright © 2018 Adam Kirk. All rights reserved.
//

import Foundation

enum DateComponent {
    case year, years
    case month, months
    case week, weeks
    case day, days
    case hour, hours
    case minute, minutes
    case second, seconds
}

enum DateBoundary {
    case start, end
}

enum DateTense {
    case since, until
}

enum SymbolUnit {
    case weekday, month, quarter, era
}

enum SymbolLength {
    case long, standard, short, veryShort
}

class Jumper {
    public static var calendar: Calendar = Calendar.current
}

enum FormatterStyleType {
    case date, time
}

extension Date {
    
    // Date(ISOString: String)
    init?(ISOString: String) {
        if #available(iOS 10.0, macOS 10.12, watchOS 3.0, tvOS 10.0, *) {
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime]
            if let date = formatter.date(from: ISOString)  {
                self = date
            }
            else {
                return nil
            }
        } else {
            let formatter = DateFormatter()
            formatter.calendar = Jumper.calendar
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = Jumper.calendar.timeZone
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
            if let date = formatter.date(from: ISOString)  {
                self = date
            }
            else {
                return nil
            }
        }
    }
    
    // Date(string: String format: String)
    init?(string: String, format: String) {
        let formatter = DateFormatter()
        formatter.timeZone = Jumper.calendar.timeZone
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
        components.timeZone = Jumper.calendar.timeZone
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
        var components = Jumper.calendar.dateComponents(in: TimeZone(secondsFromGMT: 0)!, from: self)
        for pair in param {
            switch pair {
            case let (.year, value), let (.years, value):
                components.year = value
            case let (.month, value), let (.months, value):
                components.month = value
            case let (.week, value), let (.weeks, value):
                components.weekOfYear = value
            case let (.day, value), let (.days, value):
                components.day = value
            case let (.hour, value), let (.hours, value):
                components.hour = value
            case let (.minute, value), let (.minutes, value):
                components.minute = value
            case let (.second, value), let (.seconds, value):
                components.minute = value
            }
        }
        return Jumper.calendar.date(from: components)!
    }
    
    // move([.Month: 3])
    func move(_ param: [DateComponent: Int]) -> Date {
        var components = DateComponents()
        components.timeZone = Jumper.calendar.timeZone
        for pair in param {
            switch pair {
            case let (.year, value), let (.years, value):
                components.year = value
            case let (.month, value), let (.months, value):
                components.month = value
            case let (.week, value), let (.weeks, value):
                components.weekOfYear = value
            case let (.day, value), let (.days, value):
                components.day = value
            case let (.hour, value), let (.hours, value):
                components.hour = value
            case let (.minute, value), let (.minutes, value):
                components.minute = value
            case let (.second, value), let (.seconds, value):
                components.minute = value
            }
        }
        return Jumper.calendar.date(byAdding: components, to: self)!
    }
    
    // clamp(.Start, .Month, -1)
    func clamp(to boundary: DateBoundary, of comp: DateComponent, _ offset: Int = 0) -> Date {
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
            _ = Jumper.calendar.dateInterval(of: unit, start: &startOf, interval: &interval, for: date)
            return startOf
        case .end:
            let unit = Date.toNativeUnits(comp)
            var interval = TimeInterval(0)
            var startOf = Date()
            _ = Jumper.calendar.dateInterval(of: unit, start: &startOf, interval: &interval, for: date)
            return startOf.addingTimeInterval(interval - 1)
        }
    }
    
    // what(.Day, of: .Year)
    func what(_ inner: DateComponent, of outer: DateComponent) -> Int {
        return Jumper.calendar.ordinality(of: Date.toNativeUnits(inner), in: Date.toNativeUnits(outer), for: self)!
    }
    
    // diff(.Years, .Since, date)
    func diff(_ unit: DateComponent, _ tense: DateTense, _ target: Date) -> Int {
        var components: DateComponents
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
        let date: Date
        if offset != 0 {
            date = move([outer: offset])
        }
        else {
            date = self
        }
        if let result = Jumper.calendar.range(of: Date.toNativeUnits(unit, outer), in: Date.toNativeUnits(outer), for: date) {
            return result.count
        }
        return nil
    }
    
    func within(same unit: DateComponent, of other: Date) -> Bool {
        return Jumper.calendar.isDate(self, equalTo: other, toGranularity: Date.toNativeUnits(unit))
    }
    
    // string([.date: .long, .time: .short]) //=> "July 11, 1986 at 10:17 AM"
    func string(_ format: [FormatterStyleType: DateFormatter.Style]) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = Jumper.calendar.timeZone
        for (t, style) in format {
            switch t {
            case .date: formatter.dateStyle = style
            case .time: formatter.timeStyle = style
            }
        }
        return formatter.string(from: self)
    }
    
    // string("YYYY-MM-dd") //=> "1986-07-11"
    func string(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = Jumper.calendar.timeZone
        formatter.dateFormat = format
        return formatter.string(from: self)
    }

    private static func toNativeUnits(_ comp: DateComponent, _ outer: DateComponent? = nil) -> Calendar.Component {
        switch comp {
        case .year, .years: return .year
        case .month, .months: return .month
        case .week, .weeks: return .weekOfYear
        case .day, .days: return .day
        case .hour, .hours: return .hour
        case .minute, .minutes: return .minute
        case .second, .seconds: return .second
        }
    }
}

extension DateFormatter {
    
    // NSDateFormatter.symbols(.Weekday, .Short)
    static func symbols(_ unit: SymbolUnit, _ length: SymbolLength, _ standalone: Bool = true) -> [String] {
        let c = Jumper.calendar
        switch unit {
        case .weekday:
            switch length {
            case .long: return standalone ? c.standaloneWeekdaySymbols: c.weekdaySymbols
            case .standard: return standalone ? c.standaloneWeekdaySymbols : c.weekdaySymbols
            case .short: return standalone ? c.shortStandaloneWeekdaySymbols : c.shortWeekdaySymbols
            case .veryShort: return standalone ? c.veryShortStandaloneWeekdaySymbols : c.shortWeekdaySymbols
            }
        case .month:
            switch length {
            case .long: return standalone ? c.standaloneMonthSymbols: c.monthSymbols
            case .standard: return standalone ? c.standaloneMonthSymbols : c.monthSymbols
            case .short: return standalone ? c.shortStandaloneMonthSymbols : c.shortMonthSymbols
            case .veryShort: return standalone ? c.veryShortStandaloneMonthSymbols : c.veryShortMonthSymbols
            }
        case .quarter:
            switch length {
            case .long: return standalone ? c.standaloneQuarterSymbols: c.quarterSymbols
            case .standard: return standalone ? c.standaloneQuarterSymbols : c.quarterSymbols
            case .short: return standalone ? c.shortStandaloneQuarterSymbols : c.shortQuarterSymbols
            case .veryShort: return standalone ? c.shortStandaloneQuarterSymbols : c.shortQuarterSymbols
            }
        case .era:
            switch length {
            case .long: return c.longEraSymbols
            case .standard: return c.eraSymbols
            case .short: return c.eraSymbols
            case .veryShort: return c.eraSymbols
            }
        }
    }
}
