//
//  DispatchTimerTests.swift
//  ELDispatch
//
//  Created by Sam Grover on 2/3/16.
//  Copyright © 2016 WalmartLabs. All rights reserved.
//

import XCTest
import ELDispatch

class DispatchTimerTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testSchedule() {
        let expectation = self.expectationWithDescription("timer fired")
        let queue = DispatchQueue.Background
        let timer = DispatchTimer()
        timer.schedule(queue, interval: 1) {
            expectation.fulfill()
        }

        self.waitForExpectationsWithTimeout(10, handler: nil)
    }

    func testScheduleSuspendedStart() {
        let expectation = self.expectationWithDescription("timer fired")
        let queue = DispatchQueue.Background
        let timer = DispatchTimer()
        timer.schedule(queue, interval: 1, delay: 0, leeway: 1, suspended: true) {
            expectation.fulfill()
        }
        
        timer.resume()
        
        self.waitForExpectationsWithTimeout(10, handler: nil)
    }

    func testScheduleRepetition() {
        let queue = DispatchQueue.Background
        var testValue = 0
        
        let timer = DispatchTimer()
        timer.schedule(queue, interval: 0.25) {
            testValue += 1
        }
        
        try! self.waitForConditionsWithTimeout(1) { () -> Bool in
            return false
        }
        
        XCTAssertTrue(testValue > 3)
    }
    
    func testCancel() {
        let queue = DispatchQueue.Background
        var testValue = 0
        
        let timer = DispatchTimer()
        timer.schedule(queue, interval: 0.25) {
            testValue += 1
        }
        
        try! self.waitForConditionsWithTimeout(1) { () -> Bool in
            return false
        }
        
        XCTAssertTrue(testValue > 3)
        let finalTestValue = testValue
        timer.cancel()

        try! self.waitForConditionsWithTimeout(0.5) { () -> Bool in
            return false
        }
        
        XCTAssertTrue(testValue == finalTestValue)
    }
    
    func testSuspendAndResume() {
        let queue = DispatchQueue.Background
        var testValue = 0
        
        let timer = DispatchTimer()
        timer.schedule(queue, interval: 0.25) {
            testValue += 1
        }
        
        try! self.waitForConditionsWithTimeout(1) { () -> Bool in
            return false
        }
        
        XCTAssertTrue(testValue > 3)
        
        let preSuspendTestValue = testValue
        
        timer.suspend()
        XCTAssertTrue(timer.suspended)
        
        try! self.waitForConditionsWithTimeout(0.5) { () -> Bool in
            return false
        }
        
        XCTAssertTrue(testValue == preSuspendTestValue)
        timer.resume()
        
        try! self.waitForConditionsWithTimeout(0.5) { () -> Bool in
            return false
        }
        
        XCTAssertTrue(testValue > preSuspendTestValue)
    }
}
