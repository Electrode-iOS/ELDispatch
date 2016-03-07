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

//    func testSchedule() {
//        let expectation = self.expectationWithDescription("timer fired")
//        let serialQueue = DispatchQueue.Background
//        let timer = DispatchTimer()
//        timer.schedule(serialQueue, interval: 5) {
//            expectation.fulfill()
//        }
//        NSRunLoop.currentRunLoop().runUntilDate(NSDate.distantPast())
//        self.waitForExpectationsWithTimeout(10, handler: nil)
//    }

}
