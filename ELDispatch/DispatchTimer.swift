//
//  DispatchTimer.swift
//  ELDispatch
//
//  Created by Brandon Sneed on 2/15/15.
//  Copyright (c) 2015 WalmartLabs. All rights reserved.
//

import Foundation
#if NOFRAMEWORKS
#else
import ELFoundation
#endif

/// Represents a GCD timer.
public class DispatchTimer {
    /// Initializes a new dispatch timer.
    public init () {
        // nothing to do here.  yet.
    }
    
    /// The state of the timer.  `true` means the timer is suspended.  `false` means that it isn't.
    public var suspended: Bool {
        get {
            return lock.around {
                return self.isSuspended
            }
        }
        
        set(value) {
            lock.around {
                self.isSuspended = value
            }
        }
    }
    
    private var rawTimer: dispatch_source_t? = nil
    private let lock: Spinlock = Spinlock()
    private var isSuspended: Bool = false
    
    /**
     Schedules a GCD timer on the specified queue.
     
     - parameter queue: The target queue.
     - parameter interval: The interval at which to execute the closure, in seconds.
     - parameter delay: The time to wait before the timer beings, in seconds.  The default is 0.
     - parameter leeway: A hint as to the leeway by which GCD may have to execute the closure.  The default is 0.2.
     - parameter suspended: The timer will be created in a suspended state.
     - parameter closure: The closure to execute.
    */
    public func schedule(queue: DispatchQueue, interval: NSTimeInterval, delay: NSTimeInterval = 0, leeway: NSTimeInterval = 1, suspended: Bool = false, _ closure: () -> Void) -> DispatchClosure {
        // if we have a timer object already, lets bolt.
        if self.rawTimer != nil {
            exceptionFailure("A timer has already been scheduled!")
        }
        
        // set this to the opposite of the 'suspeded' var that came in.
        // it'll get set to the proper state after.
        isSuspended = suspended
        
        
        let rawTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue.dispatchQueue())
        self.rawTimer = rawTimer
        
        var startTime: dispatch_time_t
        
        if delay == 0 {
            startTime = DISPATCH_TIME_NOW
        } else {
            startTime = dispatch_time(DISPATCH_TIME_NOW, Int64(interval * NSTimeInterval(NSEC_PER_SEC)))
        }
        
        let repeatInterval = UInt64(interval * NSTimeInterval(NSEC_PER_SEC))
        let leewayTime = UInt64(leeway * NSTimeInterval(NSEC_PER_SEC))
        
        dispatch_source_set_event_handler(rawTimer, closure)
        dispatch_source_set_timer(rawTimer, startTime, repeatInterval, leewayTime)
        
        if suspended == false {
            dispatch_resume(rawTimer)
        }
        
        return DispatchClosure(closure)
    }
    
    /**
     Cancels the timer.
    */
    public func cancel() {
        if let timer = rawTimer {
            dispatch_source_cancel(timer)
            rawTimer = nil;
        }
    }
    
    /**
     Suspends execution of the timer.  Call `resume()` to begin again.
    */
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
    
    /**
     Resumes a timer.  Call `suspend()` to suspend it.
    */
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
}
