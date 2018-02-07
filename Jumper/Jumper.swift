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
    case Start, End
}

class Jumper {
    public static var calendar: Calendar = Calendar.current
}

extension Date {
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
    
    func clamp(_ boundary: DateBoundary, _ comp: DateComponent, _ offset: Int = 0) -> Date {
        switch boundary {
        case .Start:
            let units: Set<Calendar.Component>
            switch comp {
            case .Year, .Years:
                units = [.year]
            case .Month, .Months:
                units = [.year, .month]
            case .Week, .Weeks:
                units = [.yearForWeekOfYear, .weekOfYear]
            case .Day, .Days:
                units = [.year, .month, .day]
            case .Hour, .Hours:
                units = [.year, .month, .day, .hour]
            case .Minute, .Minutes:
                units = [.year, .month, .day, .hour, .minute]
            case .Second, .Seconds:
                units = [.year, .month, .day, .hour, .minute, .second]
            }
            let components = Jumper.calendar.dateComponents(units, from: self)
            return Jumper.calendar.date(from: components)!
        case .End:
            
            nil
//            switch comp {
//            case .Year, .Years:
//
//            case .Month, .Months:
//                units = [.year, .month]
//            case .Week, .Weeks:
//                units = [.yearForWeekOfYear, .weekOfYear]
//            case .Day, .Days:
//                units = [.year, .month, .day]
//            case .Hour, .Hours:
//                units = [.year, .month, .day, .hour]
//            case .Minute, .Minutes:
//                units = [.year, .month, .day, .hour, .minute]
//            case .Second, .Seconds:
//                units = [.year, .month, .day, .hour, .minute, .second]
//            }
        }
    }
}
