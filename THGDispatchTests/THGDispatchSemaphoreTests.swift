//
//  THGDispatchSemaphoreTests.swift
//  THGDispatch
//
//  Created by Steven W. Riggins on 2/16/15.
//  Copyright (c) 2015 Walmart. All rights reserved.
//

import UIKit
import XCTest
import THGDispatch

class THGDispatchSemaphoreTests: XCTestCase {
    
    // Test a semaphore protecting two resources
    // Fire off three background tasks, each waiting 2 seconds
    // Then wait on the semaphore on the main three, wait 2 seconds, and signal it
    // Lastly, make sure that all expectations were met
    func testTripleUsage () {
        
        let expectation1 = expectationWithDescription("First semaphore signaled")
        let expectation2 = expectationWithDescription("Second semaphore signaled")
        let expectation3 = expectationWithDescription("Third semaphore signaled")
        
        let semaphore = DispatchSemaphore(initialValue: 2)
        
        Dispatch().async(.Background) {
            semaphore.wait()
            sleep(2)
            expectation1.fulfill()
            semaphore.signal()
        }
        
        Dispatch().async(.Background) {
            semaphore.wait()
            sleep(2)
            expectation2.fulfill()
            semaphore.signal()
        }
        
        Dispatch().async(.Background) {
            semaphore.wait()
            sleep(2)
            expectation3.fulfill()
            semaphore.signal()
        }
        
        semaphore.wait()
        sleep(2)
        semaphore.signal()
        
        self.waitForExpectationsWithTimeout(10, handler: nil)
        
    }

}