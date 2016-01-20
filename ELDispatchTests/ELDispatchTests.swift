//
//  ELDispatchTests.swift
//  ELDispatchTests
//
//  Created by Brandon Sneed on 2/10/15.
//  Copyright (c) 2015 TheHolyGrail. All rights reserved.
//

import UIKit
import XCTest
import ELDispatch

class ELDispatchTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAsync() {
        
        let expectation1 = self.expectationWithDescription("block gets executed")
        
        Dispatch().async(.Background) {
            expectation1.fulfill()
        }
        
        self.waitForExpectationsWithTimeout(1.0, handler: nil)
    }
    
    func testAsyncAndWait() {
        
        let expectation1: XCTestExpectation = self.expectationWithDescription("block gets executed")
        
        Dispatch().async(.Background) {
            // sleep longer than the waitForExpectationsWithTimeout does.
            sleep(3)
            expectation1.fulfill()
        }.wait()
        
        self.waitForExpectationsWithTimeout(0, handler: nil)
        
    }
    
    func testAsyncAndNotify() {
        
        let expectation1: XCTestExpectation = self.expectationWithDescription("block gets executed")
        let expectation2: XCTestExpectation = self.expectationWithDescription("main thread was notified")
        
        Dispatch().async(.Background) {
            expectation1.fulfill()
        }.notify(.Main) {
            XCTAssertTrue(NSThread.isMainThread())
            expectation2.fulfill()
        }
        
        self.waitForExpectationsWithTimeout(1, handler: nil)
    }
    
    func testSyncAndNotify() {
        
        let expectation1: XCTestExpectation = self.expectationWithDescription("block gets executed")
        let expectation2: XCTestExpectation = self.expectationWithDescription("main thread was notified")
        
        Dispatch().sync(.Background) {
            // sleep longer than the waitForExpectationsWithTimeout does.
            sleep(3)
            expectation1.fulfill()
        }.notify(.Main) {
            XCTAssertTrue(NSThread.isMainThread())
            expectation2.fulfill()
        }
        
        self.waitForExpectationsWithTimeout(0, handler: nil)
    }

    func testGroupAndNotify() {
        let group = DispatchGroup()

        let expectation1: XCTestExpectation = self.expectationWithDescription("first block executed on bg queue")
        let expectation2: XCTestExpectation = self.expectationWithDescription("second block executed on main thread")
        let expectation3: XCTestExpectation = self.expectationWithDescription("main thread was notified of completion")

        group.async(.Background) {
            expectation1.fulfill()
        }.async(.Utility) {
            expectation2.fulfill()
        }.notify(.Main) {
            XCTAssertTrue(NSThread.isMainThread())
            expectation3.fulfill()
        }

        self.waitForExpectationsWithTimeout(1, handler: nil)
    }
    
    func testGroupAndWait() {
        let group = DispatchGroup()
        
        let expectation1: XCTestExpectation = self.expectationWithDescription("first block executed on bg queue")
        let expectation2: XCTestExpectation = self.expectationWithDescription("second block executed on main thread")
        let expectation3: XCTestExpectation = self.expectationWithDescription("wait for group succeeded")
        
        group.async(.Background) {
            sleep(2)
            expectation1.fulfill()
        }.async(.Utility) {
            expectation2.fulfill()
        }
        
        if group.wait(3) == true {
            expectation3.fulfill()
        }
        
        self.waitForExpectationsWithTimeout(0, handler: nil)
    }

    func testGroupAndWaitFail() {
        let group = DispatchGroup()
        
        let expectation1: XCTestExpectation = self.expectationWithDescription("first block executed on bg queue")
        let expectation2: XCTestExpectation = self.expectationWithDescription("second block executed on main thread")
        let expectation3: XCTestExpectation = self.expectationWithDescription("wait for group failed")
        
        group.async(.Background) {
            XCTAssertFalse(NSThread.isMainThread())
            sleep(2)
            expectation1.fulfill()
        }.async(.Utility) {
            XCTAssertFalse(NSThread.isMainThread())
            expectation2.fulfill()
        }
        
        // don't wait long enough for 1st closure to finish.
        if group.wait(1) == false {
            expectation3.fulfill()
        }
        
        // we expected the wait to fail, so wait a little longer to see that our
        // expectations were met.
        self.waitForExpectationsWithTimeout(2, handler: nil)
    }
    
    func testSuspendFailure() {
        let queue = DispatchQueue.Background
        
        XCTAssertThrows({ Dispatch().suspend(queue) }, "The queue should throw an assertion if it's attempting to suspend a default queue!")
    }
    
    func testSerialQueue() {
        DispatchQueue.createSerial("blah")
    }
}
