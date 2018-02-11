//
//  JumperTests.swift
//  JumperTests
//
//  Created by Adam Kirk on 2/9/18.
//  Copyright © 2016 Adam Kirk. All rights reserved.
//

import XCTest
@testable import Jumper

class JumperTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
//        Jumper.calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        Jumper.calendar.timeZone = TimeZone(identifier: "America/Denver")!
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCreateWithISOString() {
        let date = Date(ISOString: "2018-01-23T03:06:46Z")!
        XCTAssertEqual(date, Date(timeIntervalSince1970: 1516676806))
    }
    
    func testCreateWithCustomFormat() {
        let date = Date(string: "1986-07-11", format: "yyyy-MM-dd")!
        XCTAssertEqual(date, Date(timeIntervalSince1970: 521_424_000 + 21_600)) // + 6 hr offset
    }

    func testCreateWithDictionary() {
        let date = Date([.year: 1986, .month: 7, .day: 11])!
        XCTAssertEqual(date, Date(timeIntervalSince1970: 521_424_000 + 21_600)) // + 6 hr offset
    }
    
    func testCreateWithComponent() {
        var comps = DateComponents(calendar: Jumper.calendar, timeZone: nil, era: nil, year: 1986, month: 7, day: 11, hour: 0, minute: nil, second: nil, nanosecond: nil, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
        comps.timeZone = TimeZone(secondsFromGMT: 0)
        let date = Date(components: comps)!
        XCTAssertEqual(date, Date(timeIntervalSince1970: 521424000))
    }
    
    func testChange() {
        let date = Date([.year: 1986, .month: 7, .day: 11])!
        let changed = date.change([.days: 4, .minutes: 3])
        let expected = Date([.year: 1986, .month: 7, .day: 4, .hour: 0, .minute: 3])
        XCTAssertEqual(changed, expected)
    }
    
    func testMoveForward() {
        let date = Date([.year: 1986, .month: 7, .day: 11])!
        let changed = date.move([.days: 4, .minutes: 3])
        let expected = Date([.year: 1986, .month: 7, .day: 15, .hour: 0, .minute: 3])
        XCTAssertEqual(changed, expected)
    }
    
    func testMoveBackward() {
        let date = Date([.year: 1986, .month: 7, .day: 11])!
        let changed = date.move([.days: -4, .minutes: -3])
        let expected = Date([.year: 1986, .month: 7, .day: 6, .hour: 23, .minute: 57])
        XCTAssertEqual(changed, expected)
    }
    
    func testClampStart() {
        let date = Date([.year: 1986, .month: 7, .day: 11])!
        let changed = date.clamp(to: .start, of: .month)
        let expected = Date([.year: 1986, .month: 7, .day: 1])
        XCTAssertEqual(changed, expected)
    }
    
    func testClampEnd() {
        let date = Date([.year: 1986, .month: 7, .day: 11])!
        let changed = date.clamp(to: .end, of: .month)
        let expected = Date([.year: 1986, .month: 7, .day: 31, .hour: 23, .minute: 59, .second: 59])
        XCTAssertEqual(changed, expected)
    }
    
    func testClampEndOfLastMonth() {
        let date = Date([.year: 1986, .month: 7, .day: 11])!
        let changed = date.clamp(to: .end, of: .month, -1)
        let expected = Date([.year: 1986, .month: 6, .day: 30, .hour: 23, .minute: 59, .second: 59])
        XCTAssertEqual(changed, expected)
    }
    
    func testWhatDay() {
        let date = Date([.year: 1986, .month: 7, .day: 11])!
        let result = date.what(.day, of: .month)
        XCTAssertEqual(result, 11)
    }
    
    func testWhatDayOfYear() {
        let date = Date([.year: 1986, .month: 7, .day: 11])!
        let result = date.what(.day, of: .year)
        XCTAssertEqual(result, 192)
    }
    
    func testWhatMonthOfYear() {
        let date = Date([.year: 1986, .month: 7, .day: 11])!
        let result = date.what(.month, of: .year)
        XCTAssertEqual(result, 7)
    }
    
    func testWhatWeekOfYear() {
        let date = Date([.year: 1986, .month: 7, .day: 11])!
        let result = date.what(.week, of: .year)
        XCTAssertEqual(result, 28)
    }
    
    func testDiffYearsUntil() {
        let date1 = Date([.year: 1986, .month: 7, .day: 11])!
        let date2 = Date([.year: 2018, .month: 2, .day: 9])!
        let result = date1.diff(.years, .until, date2)
        XCTAssertEqual(result, 31)
    }
    
    func testDiffMonthsSince() {
        let date1 = Date([.year: 1986, .month: 7, .day: 11])!
        let date2 = Date([.year: 2018, .month: 2, .day: 9])!
        let result = date2.diff(.months, .since, date1)
        XCTAssertEqual(result, 378)
    }
    
    func testDiffMinutesSinceNegative() {
        let date1 = Date([.year: 1986, .month: 7, .day: 11])!
        let date2 = Date([.year: 2018, .month: 2, .day: 9])!
        let result = date1.diff(.minutes, .since, date2)
        XCTAssertEqual(result, -16_611_900)
    }
    
    func testCountDaysInMonth() {
        let date = Date([.year: 1986, .month: 7, .day: 11])!
        let result = date.count(.days, in: .month)
        XCTAssertEqual(result, 31)
    }
    
    func testCountDaysInYear() {
        let date = Date([.year: 1986, .month: 7, .day: 11])!
        let result = date.count(.days, in: .year)
        XCTAssertEqual(result, 365)
    }
    
    func testCountDaysInLeapYear() {
        let date = Date([.year: 2016, .month: 7, .day: 11])!
        let result = date.count(.days, in: .year)
        XCTAssertEqual(result, 366)
    }
    
    func testCountDaysInLastMonth() {
        let date = Date([.year: 1986, .month: 7, .day: 11])!
        let result = date.count(.days, in: .month, -1)
        XCTAssertEqual(result, 30)
    }
    
    func testWithinSameMonth() {
        let date1 = Date([.year: 1986, .month: 7, .day: 11])!
        let date2 = Date([.year: 1986, .month: 7, .day: 9])!
        let result = date1.within(same: .month, of: date2)
        XCTAssertTrue(result)
    }
    
    func testWithinSameYear() {
        let date1 = Date([.year: 1986, .month: 7, .day: 11])!
        let date2 = Date([.year: 1986, .month: 8, .day: 9])!
        let result = date1.within(same: .year, of: date2)
        XCTAssertTrue(result)
    }
    
    func testNotWithin() {
        let date1 = Date([.year: 1986, .month: 7, .day: 11])!
        let date2 = Date([.year: 1987, .month: 8, .day: 9])!
        let result = date1.within(same: .year, of: date2)
        XCTAssertFalse(result)
    }
    
    func testMonthSymbols() {
        XCTAssertEqual(DateFormatter.symbols(.month, .short), ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"])
    }
    
    func testWeekSymbols() {
        XCTAssertEqual(DateFormatter.symbols(.weekday, .veryShort), ["S", "M", "T", "W", "T", "F", "S"])
    }
    
    func testShortDateFormat() {
        let date = Date([.year: 1986, .month: 7, .day: 11])!
        let result = date.string([.date: .short])
        XCTAssertEqual(result, "7/11/86")
    }
    
    func testShortTimeFormat() {
        let date = Date([.year: 1986, .month: 7, .day: 11, .hour: 10, .minute: 17])!
        let result = date.string([.time: .short])
        XCTAssertEqual(result, "10:17 AM")
    }
    
    func testLongDateTimeFormat() {
        let date = Date([.year: 1986, .month: 7, .day: 11, .hour: 10, .minute: 17])!
        let result = date.string([.date: .long, .time: .short])
        XCTAssertEqual(result, "July 11, 1986 at 10:17 AM")
    }
    
    func testCustomFormat() {
        let date = Date([.year: 1986, .month: 7, .day: 11, .hour: 10, .minute: 17])!
        let result = date.string("YYYY-MM-dd")
        XCTAssertEqual(result, "1986-07-11")
    }
}

















