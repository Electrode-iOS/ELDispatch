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
        let interval = 0.1
        var testValue = 0
        
        let timer = DispatchTimer()
        timer.schedule(queue, interval: interval) {
            testValue += 1
        }
        
        do {
            try self.waitForConditionsWithTimeout(1) {
                return testValue > 3
            }
        } catch {
            XCTAssertTrue(false, "Timed out waiting for repetition")
        }
        
        XCTAssertTrue(testValue > 3)
    }
    
    func testCancel() {
        let queue = DispatchQueue.Background
        let interval = 0.1
        var testValue = 0
        
        let timer = DispatchTimer()
        timer.schedule(queue, interval: interval) {
            testValue += 1
        }
        
        do {
            try self.waitForConditionsWithTimeout(1) {
                return testValue > 2
            }
        } catch {
            XCTAssertTrue(false, "Timed out waiting for repetition")
        }
        
        XCTAssertTrue(testValue > 2)
        let finalTestValue = testValue
        timer.cancel()

        do {
            try self.waitForConditionsWithTimeout(interval * 2) { () -> Bool in
                return false
            }
        } catch {}
        
        XCTAssertTrue(testValue == finalTestValue)
    }
    
    func testSuspendAndResume() {
        let queue = DispatchQueue.Background
        let interval = 0.1
        var testValue = 0
        
        let timer = DispatchTimer()
        timer.schedule(queue, interval: interval) {
            testValue += 1
        }
        
        do {
            try self.waitForConditionsWithTimeout(1) {
                return testValue > 2
            }
        } catch {
            XCTAssertTrue(false, "Timed out waiting for repetition")
        }
        
        XCTAssertTrue(testValue > 2)
        
        let preSuspendTestValue = testValue
        
        timer.suspend()
        XCTAssertTrue(timer.suspended)
        
        do {
            try self.waitForConditionsWithTimeout(interval * 2) { () -> Bool in
                return false
            }
        } catch {}
        
        XCTAssertTrue(testValue == preSuspendTestValue)
        timer.resume()
        
        do {
            try self.waitForConditionsWithTimeout(interval * 2) {
                return testValue > preSuspendTestValue
            }
        } catch {
            XCTAssertTrue(false, "Timed out waiting for repetition")
        }
        
        XCTAssertTrue(testValue > preSuspendTestValue)
    }
}
