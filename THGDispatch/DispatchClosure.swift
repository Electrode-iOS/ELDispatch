//
//  DispatchClosure.swift
//  THGDispatch
//
//  Created by Brandon Sneed on 2/15/15.
//  Copyright (c) 2015 TheHolyGrail. All rights reserved.
//

import Foundation

public struct DispatchClosure {
    
    public init(_ closure: () -> Void) {
        rawObject = dispatch_block_create(DISPATCH_BLOCK_INHERIT_QOS_CLASS) {
            autoreleasepool(closure)
        }
    }
    
    public func notify(queue: DispatchQueue, closure: () -> Void) -> DispatchClosure {
        let wrappedClosure = DispatchClosure(closure)
        dispatch_block_notify(rawObject, queue.dispatchQueue(), wrappedClosure.rawObject)
        
        return wrappedClosure
    }
    
    public func wait() {
        dispatch_block_wait(rawObject, DISPATCH_TIME_FOREVER)
    }
    
    public func wait(timeout: NSTimeInterval) -> Bool {
        let dispatchTimeout = dispatch_time(DISPATCH_TIME_NOW, Int64(timeout * NSTimeInterval(NSEC_PER_SEC)))
        
        // result == 1 if it was a success, 0 if it timed out.
        let result = dispatch_block_wait(rawObject, dispatchTimeout)
        return result == 0
    }
    
    public func closure() -> dispatch_block_t {
        return rawObject
    }
    
    private let rawObject: dispatch_block_t
}