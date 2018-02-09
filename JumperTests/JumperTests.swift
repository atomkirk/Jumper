//
//  JumperTests.swift
//  JumperTests
//
//  Created by Adam Kirk on 1/6/16.
//  Copyright © 2016 Adam Kirk. All rights reserved.
//

import XCTest
@testable import Jumper

class JumperTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
//    func testExample() {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//        let date = Date(ISOString: "")
//    }
    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
    func testCreateWithISOString() {
        let date = Date(ISOString: "2018-01-23T03:06:46Z")!
        XCTAssertEqual(date, Date(timeIntervalSince1970: 1516676806))
    }
    
    func testCreateWithCustomFormat() {
        let date = Date(string: "1986-07-11", format: "yyyy-MM-dd")!
        XCTAssertEqual(date, Date(timeIntervalSince1970: 521424000))
    }

    func testCreateWithDictionary() {
        let date = Date([.Year: 1986, .Month: 7, .Day: 11])!
        XCTAssertEqual(date, Date(timeIntervalSince1970: 521424000))
    }
    
    func testCreateWithComponent() {
        var comps = DateComponents(calendar: Jumper.calendar, timeZone: nil, era: nil, year: 1986, month: 7, day: 11, hour: 0, minute: nil, second: nil, nanosecond: nil, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
        comps.timeZone = TimeZone(secondsFromGMT: 0)
        let date = Date(components: comps)!
        XCTAssertEqual(date, Date(timeIntervalSince1970: 521424000))
    }
    
    func testChange() {
        let date = Date([.Year: 1986, .Month: 7, .Day: 11])!
        let changed = date.change([.Days: 4, .Minutes: 3])
        let expected = Date([.Year: 1986, .Month: 7, .Day: 4, .Hour: 0, .Minute: 3])
        XCTAssertEqual(changed, expected)
    }
}
