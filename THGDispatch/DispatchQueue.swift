//
//  DispatchQueue.swift
//  THGDispatch
//
//  Created by Brandon Sneed on 2/10/15.
//  Copyright (c) 2015 TheHolyGrail. All rights reserved.
//
//  Based on GCDKit by John Estropia

import Foundation

public enum DispatchQueue {
    
    /**
    Returns the serial dispatch queue associated with the application’s main thread.
    */
    case Main
    case Background
    case UserInteractive
    case UserInitiated
    case Default
    case Utility
    case Serial(label: String)
    case Concurrent(label: String)
    
    public func dispatchQueue() -> dispatch_queue_t {
        // we need to store these into a rawObject private var so we don't run
        // the risk to creating multiple queues for serial and concurrent.
        switch self {
            
        case .Main:
            return dispatch_get_main_queue()
            
        case .Background:
            return dispatch_get_global_queue(Int(QOS_CLASS_BACKGROUND.value), 0)

        case .UserInteractive:
            return dispatch_get_global_queue(Int(QOS_CLASS_USER_INTERACTIVE.value), 0)
        
        case .UserInitiated:
            return dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.value), 0)
        
        case .Default:
            return dispatch_get_global_queue(Int(QOS_CLASS_DEFAULT.value), 0)
        
        case .Utility:
            return dispatch_get_global_queue(Int(QOS_CLASS_UTILITY.value), 0)
        
        // is there a better way to do these two other than repeating code?
        case .Serial(let label):
            let bundle = NSBundle(forClass: THGDispatch.self)
            let id = (bundle.reverseBundleIdentifier() ?? "") + "." + label
            return dispatch_queue_create(id, DISPATCH_QUEUE_SERIAL)

        case .Concurrent(let label):
            let bundle = NSBundle(forClass: THGDispatch.self)
            let id = (bundle.reverseBundleIdentifier() ?? "") + "." + label
            return dispatch_queue_create(id, DISPATCH_QUEUE_CONCURRENT)
        }
    }
    
    public func async(closure: () -> Void) -> DispatchClosure {
        let wrappedClosure = DispatchClosure(closure)
        let queue = dispatchQueue()
        dispatch_async(dispatchQueue(), wrappedClosure.closure())
        return wrappedClosure
    }
    
    public func sync(closure: () -> Void) -> DispatchClosure {
        let wrappedClosure = DispatchClosure(closure)
        let queue = dispatchQueue()
        dispatch_sync(dispatchQueue(), wrappedClosure.closure())
        return wrappedClosure
    }
    
    public func barrierAsync(closure: () -> Void) -> DispatchClosure {
        let wrappedClosure = DispatchClosure(closure)
        let queue = dispatchQueue()
        dispatch_barrier_async(dispatchQueue(), wrappedClosure.closure())
        return wrappedClosure
    }
    
    public func barrierSync(closure: () -> Void) -> DispatchClosure {
        let wrappedClosure = DispatchClosure(closure)
        let queue = dispatchQueue()
        dispatch_barrier_sync(dispatchQueue(), wrappedClosure.closure())
        return wrappedClosure
    }
}

@objc public class THGDispatch {
    init() {
        assertionFailure("Do not instantiate this!")
    }
}
