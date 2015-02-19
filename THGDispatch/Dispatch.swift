//
//  Dispatch.swift
//  THGDispatch
//
//  Created by Brandon Sneed on 2/18/15.
//  Copyright (c) 2015 TheHolyGrail. All rights reserved.
//

import Foundation

public struct Dispatch {
    
    public init() {
        
    }
    
    public func async(queue: DispatchQueue, closure: () -> Void) -> DispatchClosure {
        let wrappedClosure = DispatchClosure(closure)
        dispatch_async(queue.dispatchQueue(), wrappedClosure.dispatchClosure())
        return wrappedClosure
    }
    
    public func sync(queue: DispatchQueue, closure: () -> Void) -> DispatchClosure {
        let wrappedClosure = DispatchClosure(closure)
        dispatch_sync(queue.dispatchQueue(), wrappedClosure.dispatchClosure())
        return wrappedClosure
    }
    
    public func after(queue: DispatchQueue, delay: NSTimeInterval, closure: () -> Void) -> DispatchClosure {
        let wrappedClosure = DispatchClosure(closure)
        let dispatchDelay = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * NSTimeInterval(NSEC_PER_SEC)))
        dispatch_after(dispatchDelay, queue.dispatchQueue(), wrappedClosure.dispatchClosure())
        return wrappedClosure
    }
    
    public func barrierAsync(queue: DispatchQueue, closure: () -> Void) -> DispatchClosure {
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
        case .Custom(let rawQueue):
            dispatch_suspend(rawQueue)
        default:
            assertionFailure("You can only suspend custom queues, not system queues!")
        }
    }
    
    public func resume(queue: DispatchQueue) {
        switch queue {
        case .Custom(let rawQueue):
            dispatch_resume(rawQueue)
        default:
            assertionFailure("You can only suspend custom queues, not system queues!")
        }
    }
    
}
