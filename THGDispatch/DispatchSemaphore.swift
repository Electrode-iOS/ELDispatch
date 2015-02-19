//
//  DispatchSemaphore.swift
//  THGDispatch
//
//  Created by Steven W. Riggins on 2/16/15.
//  Copyright (c) 2015 TheHolyGrail. All rights reserved.
//

import Foundation

public struct DispatchSemaphore {

    public init(initialValue: Int) {
        rawObject = dispatch_semaphore_create(initialValue)
    }
    
    public func wait() {
        dispatch_semaphore_wait(rawObject, DISPATCH_TIME_FOREVER)
    }
    
    public func wait(timeout: NSTimeInterval) -> Bool {
        let dispatchTimeout = dispatch_time(DISPATCH_TIME_NOW, Int64(timeout * NSTimeInterval(NSEC_PER_SEC)))
        
        // result == 1 if it was a success, 0 if it timed out.
        let result = dispatch_semaphore_wait(rawObject, dispatchTimeout)
        return result == 0
    }
    
    public func signal() {
        dispatch_semaphore_signal(rawObject)
    }
    
    private let rawObject: dispatch_semaphore_t
}