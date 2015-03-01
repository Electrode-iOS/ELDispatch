//
//  DispatchClosure.swift
//  THGDispatch
//
//  Created by Brandon Sneed on 2/15/15.
//  Copyright (c) 2015 TheHolyGrail. All rights reserved.
//

import Foundation

/**
A representation of a closure / GCD block
*/
public struct DispatchClosure {
    
    /**
    Initializes a new closure representation.

    :param: closure The closure to be contained within.
    */
    public init(_ closure: () -> Void) {
        rawObject = dispatch_block_create(DISPATCH_BLOCK_INHERIT_QOS_CLASS) {
            autoreleasepool(closure)
        }
    }
    
    /**
    Schedule a closure to be submitted to the specified queue when the execution
    of a previous closure has completed.
    
    See also: `dispatch_block_notify`

    :param: queue The queue to which the supplied notification closure will be submitted when the observed closure completes.
    :param: closure The closure to be executed when the previously chained/observed closure completes.
    :returns: A DispatchClosure that can be further chained if desired.
    */
    public func notify(queue: DispatchQueue, closure: () -> Void) -> DispatchClosure {
        let wrappedClosure = DispatchClosure(closure)
        dispatch_block_notify(rawObject, queue.dispatchQueue(), wrappedClosure.rawObject)
        
        return wrappedClosure
    }
    
    /**
    Waits for the previously scheduled closure to complete.
    
    See also: `dispatch_block_wait`
    */
    public func wait() {
        dispatch_block_wait(rawObject, DISPATCH_TIME_FOREVER)
    }
    
    /**
    Waits for the previously scheduled closure to complete, or times out.
    
    See also: `dispatch_block_wait`

    :param: timeout The timeout interval in seconds.
    :returns: true if succesful, false if timed out.
    */
    public func wait(timeout: NSTimeInterval) -> Bool {
        let dispatchTimeout = dispatch_time(DISPATCH_TIME_NOW, Int64(timeout * NSTimeInterval(NSEC_PER_SEC)))
        
        // result == 1 if it was a success, 0 if it timed out.
        let result = dispatch_block_wait(rawObject, dispatchTimeout)
        return result == 0
    }
    
    /**
    Returns the raw dispatch_block_t represented.
    */
    public func dispatchClosure() -> dispatch_block_t {
        return rawObject
    }
    
    private let rawObject: dispatch_block_t
}