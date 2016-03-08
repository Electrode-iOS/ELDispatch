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

    func testScheduleSuspended() {
        let expectation = self.expectationWithDescription("timer fired")
        let queue = DispatchQueue.Background
        let timer = DispatchTimer()
        timer.schedule(queue, interval: 1, delay: 0, leeway: 1, suspended: true) {
            expectation.fulfill()
        }
        
        timer.resume()
        
        self.waitForExpectationsWithTimeout(10, handler: nil)
    }
    
    func testScheduleCancel() {
        let expectation = self.expectationWithDescription("test value checked")
        let queue = DispatchQueue.createSerial("serial")
        
        var testValue = 1
        
        let timer2 = DispatchTimer()
        timer2.schedule(queue, interval: 1) {
            testValue = 10
        }
        
        let timer1 = DispatchTimer()
        timer1.schedule(queue, interval: 2) {
            testValue = 7
        }
        
        let timer3 = DispatchTimer()
        timer3.schedule(queue, interval: 4) {
            XCTAssertEqual(testValue, 10)
            expectation.fulfill()
        }
        
        timer1.cancel()
        
        self.waitForExpectationsWithTimeout(5, handler: nil)
    }
}
