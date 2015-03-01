//
//  DispatchSemaphore.swift
//  THGDispatch
//
//  Created by Steven W. Riggins on 2/16/15.
//  Copyright (c) 2015 TheHolyGrail. All rights reserved.
//

import Foundation

public struct DispatchSemaphore {

    /**
    Initializes a new semaphore.
    
    Passing zero for the value is useful for when two threads need to reconcile
    the completion of a particular event. Passing a value greather than zero is
    useful for managing a finite pool of resources, where the pool size is equal
    to the value.

    :param: initialValue The starting value for the semaphore.
    */
    public init(initialValue: Int) {
        rawObject = dispatch_semaphore_create(initialValue)
    }
    
    /**
    Wait (decrement) for the semaphore.  If the resulting value is less than zero,
    this function waits for a signal to occur before returning.
    */
    public func wait() {
        dispatch_semaphore_wait(rawObject, DISPATCH_TIME_FOREVER)
    }
    
    /**
    Wait (decrement) for the semaphore.  If the resulting value is less than zero,
    this function waits for a signal to occur before returning.
    
    :param: timeout Timeout, in seconds.
    :returns: true if succesful, false if timed out.
    */
    public func wait(timeout: NSTimeInterval) -> Bool {
        let dispatchTimeout = dispatch_time(DISPATCH_TIME_NOW, Int64(timeout * NSTimeInterval(NSEC_PER_SEC)))
        
        // result == 1 if it was a success, 0 if it timed out.
        let result = dispatch_semaphore_wait(rawObject, dispatchTimeout)
        return result == 0
    }
    
    /**
    Signal (increment) the semaphore.  If the previous value was less than zero,
    this function wakes a waiting thread before returning.
    */
    public func signal() {
        dispatch_semaphore_signal(rawObject)
    }
    
    private let rawObject: dispatch_semaphore_t
}