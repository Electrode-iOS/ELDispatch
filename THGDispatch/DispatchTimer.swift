//
//  DispatchTimer.swift
//  THGDispatch
//
//  Created by Brandon Sneed on 2/15/15.
//  Copyright (c) 2015 TheHolyGrail. All rights reserved.
//

import Foundation
import THGFoundation

public class DispatchTimer {
    
    public init () {
        
    }
    
    public func schedule(queue: DispatchQueue, delay: NSTimeInterval = 0, leeway: NSTimeInterval = 0.2, interval: NSTimeInterval, _ closure: () -> Void) -> DispatchClosure {
        /*if cancelled {
            exceptionFailure("This timer has already been cancelled, you can't reuse it!")
        }*/
        
        // if we have a timer object already, lets bolt.
        if rawTimer != nil {
            exceptionFailure("A timer has already been scheduled!")
        }
        
        rawTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue.dispatchQueue())
        
        let wrappedClosure = DispatchClosure(closure)
        
        var startTime: dispatch_time_t
        
        if delay == 0 {
            startTime = DISPATCH_TIME_NOW
        } else {
            startTime = dispatch_time(DISPATCH_TIME_NOW, Int64(interval * NSTimeInterval(NSEC_PER_SEC)))
        }
        
        let repeatInterval = UInt64(interval * NSTimeInterval(NSEC_PER_SEC))
        let leewayTime = UInt64(leeway * NSTimeInterval(NSEC_PER_SEC))
        
        dispatch_source_set_timer(rawTimer!, startTime, repeatInterval, leewayTime)
        dispatch_source_set_event_handler(rawTimer!, wrappedClosure.dispatchClosure())
        dispatch_resume(rawTimer!)
        
        return wrappedClosure
    }
    
    public func cancel() {
        if let timer = rawTimer {
            dispatch_source_cancel(timer)
            rawTimer = nil;
        }
    }
    
    public func suspend() {
        if let timer = rawTimer {
            if !suspended {
                dispatch_suspend(timer)
                suspended = true
            }
        } else {
            // throw an error?
        }
    }
    
    public func resume() {
        if let timer = rawTimer {
            if suspended {
                dispatch_resume(timer)
                suspended = false
            }
        } else {
            // throw an error?
        }
    }
    
    private var suspended: Bool {
        get {
            return lock.around {
                self.suspended
            }
        }
        
        set(value) {
            lock.around {
                self.suspended = value
            }
        }
    }
    
    private var rawTimer: dispatch_source_t? = nil
    private var lock: Spinlock = Spinlock()
}