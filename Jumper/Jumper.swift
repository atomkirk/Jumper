//
//  Jumper.swift
//  Jumper
//
//  Created by Adam Kirk on 2/6/18.
//  Copyright © 2018 Adam Kirk. All rights reserved.
//

import Foundation

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
}

extension Date {
    
    // Date(ISOString: String)
    init?(ISOString: String) {
        if #available(iOS 10.0, *) {
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
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
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
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
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
        components.timeZone = TimeZone(secondsFromGMT: 0)
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
