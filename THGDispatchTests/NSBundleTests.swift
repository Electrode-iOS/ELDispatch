//
//  NSBundleTests.swift
//  THGDispatch
//
//  Created by Brandon Sneed on 2/16/15.
//  Copyright (c) 2015 TheHolyGrail. All rights reserved.
//

import UIKit
import XCTest
import THGDispatch
import Foundation

class NSBundleTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testReverseBundleID() {
        
        let id = NSBundle(forClass: THGDispatch.self)
        let label = "doofus"
        
        println("reversedID = %@", id.reverseBundleIdentifier()!)
        
        // does this actually work?
        let anotherid = (id.reverseBundleIdentifier() ?? "") + "." + label
        println("reversedID = %@", anotherid)

        // does this actually work?
        let nilIdentifier: String? = nil
        let yetAnotherid = (nilIdentifier ?? "") + "." + label
        
        println("reversedID = %@", yetAnotherid)

    }
    
}
