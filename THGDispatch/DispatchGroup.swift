//
//  DispatchGroup.swift
//  THGDispatch
//
//  Created by Brandon Sneed on 2/15/15.
//  Copyright (c) 2015 TheHolyGrail. All rights reserved.
//

import Foundation

public struct DispatchGroup {
    
    public init() {
        rawObject = dispatch_group_create()
    }
    
    public func async(queue: DispatchQueue, _ closure: () -> Void) -> DispatchGroup {
        dispatch_group_async(rawObject, queue.dispatchQueue()) {
            autoreleasepool(closure)
        }
        
        return self;
    }
    
    public func notify(queue: DispatchQueue, _ closure: () -> Void) {
        dispatch_group_notify(rawObject, queue.dispatchQueue()) {
            autoreleasepool(closure)
        }
    }
    
    public func wait() {
        dispatch_group_wait(rawObject, DISPATCH_TIME_FOREVER)
    }
    
    public func wait(timeout: NSTimeInterval) -> Bool {
        let dispatchTimeout = dispatch_time(DISPATCH_TIME_NOW, Int64(timeout * NSTimeInterval(NSEC_PER_SEC)))
        
        // result == 1 if it was a success, 0 if it timed out.
        let result = dispatch_group_wait(rawObject, dispatchTimeout)
        return result == 0
    }
    
    /* Not sure we want these.
    public func enter() {
        dispatch_group_enter(rawObject)
    }
    
    public func leave() {
        dispatch_group_leave(rawObject)
    }

    
    public func dispatchGroup() -> dispatch_group_t {
        return rawObject
    }*/
    
    private let rawObject: dispatch_group_t
}