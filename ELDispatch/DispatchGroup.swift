//
//  DispatchGroup.swift
//  ELDispatch
//
//  Created by Brandon Sneed on 2/15/15.
//  Copyright (c) 2015 TheHolyGrail. All rights reserved.
//

import Foundation

/**
Represents a GCD dispatch group.
*/
public struct DispatchGroup {
    
    /**
    Initializes a new dispatch group.
    */
    public init() {
        rawObject = dispatch_group_create()
    }
    
    /**
    Executes a closure asynchronously on the specified queue.

    - parameter queue: The queue that the closure should be dispatched on.
    - parameter closure: The closure to be executed on the given queue.
    - returns: A chainable DispatchGroup.
    */
    public func async(queue: DispatchQueue, _ closure: () -> Void) -> DispatchGroup {
        dispatch_group_async(rawObject, queue.dispatchQueue()) {
            autoreleasepool(closure)
        }
        
        return self;
    }
    
    /**
    Schedules a closure to be submitted to a queue when a group of previously submitted closures have completed.
    
    See also: `dispatch_group_notify`
    
    - parameter queue: The queue to which the supplied notification closure will be submitted when the observed closure completes.
    - parameter closure: The closure to be executed when the previously chained/observed closure completes.
    - returns: A DispatchClosure that can be further chained if desired.
    */
    public func notify(queue: DispatchQueue, _ closure: () -> Void) {
        dispatch_group_notify(rawObject, queue.dispatchQueue()) {
            autoreleasepool(closure)
        }
    }
    
    /**
    Waits synchronously for the previously submitted block objects to complete.
    */
    public func wait() {
        dispatch_group_wait(rawObject, DISPATCH_TIME_FOREVER)
    }

    /**
    Waits synchronously for the previously submitted block objects to complete; 
    returns if the closures do not complete before the specified timeout period has elapsed.
    */
    public func wait(timeout: NSTimeInterval) -> Bool {
        let dispatchTimeout = dispatch_time(DISPATCH_TIME_NOW, Int64(timeout * NSTimeInterval(NSEC_PER_SEC)))
        
        // result == 1 if it was a success, 0 if it timed out.
        let result = dispatch_group_wait(rawObject, dispatchTimeout)
        return result == 0
    }
    
    /**
    Returns the raw dispatch group represented.
    */
    public func dispatchGroup() -> dispatch_group_t {
        return rawObject
    }
    
    private let rawObject: dispatch_group_t
}
