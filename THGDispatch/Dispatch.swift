//
//  Dispatch.swift
//  THGDispatch
//
//  Created by Brandon Sneed on 2/18/15.
//  Copyright (c) 2015 TheHolyGrail. All rights reserved.
//

import Foundation
#if NOFRAMEWORKS
#else
import THGFoundation
#endif

/*
A struct representing a the GCD dispatch mechanism.
*/
public struct Dispatch {
    
    public init() {
        
    }
    
    /**
    Dispatches a closure asynchronously on the specified queue.
    
    - parameter queue: DispatchQueue to dispatch to.  ie: .Background
    - parameter closure: Closure to be dispatched.
    - returns: A DispatchClosure that can be used for chaining, storage, etc.
    */
    public func async(queue: DispatchQueue, closure: () -> Void) -> DispatchClosure {
        let wrappedClosure = DispatchClosure(closure)
        dispatch_async(queue.dispatchQueue(), wrappedClosure.dispatchClosure())
        return wrappedClosure
    }
    
    /**
    Dispatches a closure synchronously on the specified queue.
    
    - parameter queue: DispatchQueue to dispatch to.  ie: .Background
    - parameter closure: Closure to be dispatched.
    - returns: A DispatchClosure that can be used for chaining, storage, etc.
    */
    public func sync(queue: DispatchQueue, closure: () -> Void) -> DispatchClosure {
        let wrappedClosure = DispatchClosure(closure)
        dispatch_sync(queue.dispatchQueue(), wrappedClosure.dispatchClosure())
        return wrappedClosure
    }
    
    /**
    Dispatches a closure at a specific time on the specified queue.
    
    See also: `dispatch_after`

    - parameter queue: DispatchQueue to dispatch to.  ie: .Background
    - parameter delay: The delay before running the closure, in milliseconds.
    - parameter closure: Closure to be dispatched.
    - returns: A DispatchClosure that can be used for chaining, storage, etc.
    */
    public func after(queue: DispatchQueue, delay: NSTimeInterval, closure: () -> Void) -> DispatchClosure {
        let wrappedClosure = DispatchClosure(closure)
        let dispatchDelay = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * NSTimeInterval(NSEC_PER_SEC)))
        dispatch_after(dispatchDelay, queue.dispatchQueue(), wrappedClosure.dispatchClosure())
        return wrappedClosure
    }
    
    /**
    Submits a closure to a dispatch queue for multiple invocations.
    
    See also: `dispatch_apply`
    
    - parameter iterations: The number of iterations to perform.
    - parameter queue: The target queue to which the closure is submitted.
    - parameter closure: The closure to invoke on the target queue. The parameter passed to this closure is the current index of iteration.
    */
    public func apply(queue: DispatchQueue, iterations: Int, closure: (iteration: Int) -> Void) {
        dispatch_apply(iterations, queue.dispatchQueue()) { (iteration) -> Void in
            autoreleasepool {
                closure(iteration: iteration)
            }
        }
    }
    
    /**
    Dispatches a barrier closure asynchronously on the a concurrent queue.
    
    - parameter queue: DispatchQueue to dispatch to.  Must be a concurrent queue.
    - parameter closure: Closure to be dispatched.
    - returns: A DispatchClosure that can be used for chaining, storage, etc.
    */
    public func barrierAsync(queue: DispatchQueue, closure: () -> Void) -> DispatchClosure {
        switch queue {
        case .Concurrent( _):
            0 // do nothing.
        default:
            exceptionFailure("You can only dispatch barrier closures on a concurrent queue!")
        }

        let wrappedClosure = DispatchClosure(closure)
        dispatch_barrier_async(queue.dispatchQueue(), wrappedClosure.dispatchClosure())
        return wrappedClosure
    }
    
    /**
    Dispatches a barrier closure synchronously on the a concurrent queue.
    
    - parameter queue: DispatchQueue to dispatch to.  Must be a concurrent queue.
    - parameter closure: Closure to be dispatched.
    - returns: A DispatchClosure that can be used for chaining, storage, etc.
    */
    public func barrierSync(queue: DispatchQueue, closure: () -> Void) -> DispatchClosure {
        let wrappedClosure = DispatchClosure(closure)
        dispatch_barrier_sync(queue.dispatchQueue(), wrappedClosure.dispatchClosure())
        return wrappedClosure
    }
    
    /**
    Suspends the specified queue.
    */
    public func suspend(queue: DispatchQueue) {
        switch queue {
        case .Serial(let rawQueue):
            dispatch_suspend(rawQueue)
        case .Concurrent(let rawQueue):
            dispatch_suspend(rawQueue)
        default:
            exceptionFailure("You can only suspend custom queues, not system queues!")
        }
    }
    
    /**
    Resumes the specified queue.
    */
    public func resume(queue: DispatchQueue) {
        switch queue {
        case .Serial(let rawQueue):
            dispatch_resume(rawQueue)
        case .Concurrent(let rawQueue):
            dispatch_resume(rawQueue)
        default:
            exceptionFailure("You can only resume custom queues, not system queues!")
        }
    }
    
}
