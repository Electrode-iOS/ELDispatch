//
//  DispatchTimer.swift
//  THGDispatch
//
//  Created by Brandon Sneed on 2/15/15.
//  Copyright (c) 2015 TheHolyGrail. All rights reserved.
//

import Foundation
#if NOFRAMEWORKS
#else
import THGFoundation
#endif

/**
Represents a GCD timer.
*/
public class DispatchTimer {
    
    /**
    Initializes a new dispatch timer.
    */
    public init () {
        // nothing to do here.  yet.
    }
    
    /**
    Schedules a GCD timer on the specified queue.

    :param: queue The target queue.
    :param: interval The interval at which to execute the closure, in seconds.
    :param: delay The time to wait before the timer beings, in seconds.  The default is 0.
    :param: leeway A hint as to the leeway by which GCD may have to execute the closure.  The default is 0.2.
    :param: suspended The timer will be created in a suspended state.
    :param: closure The closure to execute.
    */
    public func schedule(queue: DispatchQueue, interval: NSTimeInterval, delay: NSTimeInterval = 0, leeway: NSTimeInterval = 0.2, suspended: Bool = false, _ closure: () -> Void) -> DispatchClosure {
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
        
        if suspended == false {
            resume()
        }
        
        return wrappedClosure
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
    
    /**
    :returns: The state of the timer.  True means the timer is suspended.  False means that it isn't.
    */
    public var suspended: Bool {
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
    private let lock: Spinlock = Spinlock()
}