//
//  Dispatch.swift
//  THGDispatch
//
//  Created by Brandon Sneed on 2/18/15.
//  Copyright (c) 2015 TheHolyGrail. All rights reserved.
//

import Foundation
import THGFoundation

public struct Dispatch {
    
    public init() {
        
    }
    
    /**
    Dispatches a closure asynchronously on the specified queue.
    
    :param: queue DispatchQueue to dispatch to.  ie: .Background
    :param: closure Closure to be dispatched.
    :returns: A DispatchClosure that can be used for chaining, storage, etc.
    */
    public func async(queue: DispatchQueue, closure: () -> Void) -> DispatchClosure {
        let wrappedClosure = DispatchClosure(closure)
        dispatch_async(queue.dispatchQueue(), wrappedClosure.dispatchClosure())
        return wrappedClosure
    }
    
    /**
    Dispatches a closure synchronously on the specified queue.
    
    :param: queue DispatchQueue to dispatch to.  ie: .Background
    :param: closure Closure to be dispatched.
    :returns: A DispatchClosure that can be used for chaining, storage, etc.
    */
    public func sync(queue: DispatchQueue, closure: () -> Void) -> DispatchClosure {
        let wrappedClosure = DispatchClosure(closure)
        dispatch_sync(queue.dispatchQueue(), wrappedClosure.dispatchClosure())
        return wrappedClosure
    }
    
    /**
    Dispatches a closure at a specific time on the specified queue.
    
    :param: queue DispatchQueue to dispatch to.  ie: .Background
    :param: delay The delay before running the closure, in milliseconds.
    :param: closure Closure to be dispatched.
    :returns: A DispatchClosure that can be used for chaining, storage, etc.
    */
    public func after(queue: DispatchQueue, delay: NSTimeInterval, closure: () -> Void) -> DispatchClosure {
        let wrappedClosure = DispatchClosure(closure)
        let dispatchDelay = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * NSTimeInterval(NSEC_PER_SEC)))
        dispatch_after(dispatchDelay, queue.dispatchQueue(), wrappedClosure.dispatchClosure())
        return wrappedClosure
    }
    
    /**
    Dispatches a closure asynchronously on the specified queue.
    
    :param: queue DispatchQueue to dispatch to.  ie: .Background
    :param: closure Closure to be dispatched.
    :returns: A DispatchClosure that can be used for chaining, storage, etc.
    */
    public func barrierAsync(queue: DispatchQueue, closure: () -> Void) -> DispatchClosure {
        switch queue {
        case .Concurrent(let rawQueue):
            0 // do nothing.
        default:
            exceptionFailure("You can only dispatch barrier closures on a concurrent queue!")
        }

        let wrappedClosure = DispatchClosure(closure)
        dispatch_barrier_async(queue.dispatchQueue(), wrappedClosure.dispatchClosure())
        return wrappedClosure
    }
    
    public func barrierSync(queue: DispatchQueue, closure: () -> Void) -> DispatchClosure {
        let wrappedClosure = DispatchClosure(closure)
        dispatch_barrier_sync(queue.dispatchQueue(), wrappedClosure.dispatchClosure())
        return wrappedClosure
    }
    
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
    
    public func resume(queue: DispatchQueue) {
        switch queue {
        case .Serial(let rawQueue):
            dispatch_suspend(rawQueue)
        case .Concurrent(let rawQueue):
            dispatch_suspend(rawQueue)
        default:
            exceptionFailure("You can only resume custom queues, not system queues!")
        }
    }
    
}
