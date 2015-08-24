//
//  DispatchQueue.swift
//  THGDispatch
//
//  Created by Brandon Sneed on 2/10/15.
//  Copyright (c) 2015 TheHolyGrail. All rights reserved.
//

import Foundation
#if NOFRAMEWORKS
#else
import THGFoundation
#endif

/**
An enum representing a GCD dispatch queue.
*/
public enum DispatchQueue {
    
    /// The serial dispatch queue associated with the application’s main thread.
    case Main
    
    /// A global concurrent queue with a Background QOS class
    case Background
    
    /// A global concurrent queue with a User-Interactive QOS class
    case UserInteractive
    
    /// A global concurrent queue with a User-Initiated QOS class
    case UserInitiated
    
    /// A global concurrent queue with the Default QOS class.
    case Default
    
    /// A global concurrent queue with the Utility QOS class.
    case Utility
    
    /// A global concurrent High-Priority queue.
    case High
    
    /// A global concurrent Low-Priority queue.
    case Low
    
    /**
    A custom serial queue.  Useful for wrapping your own queue's that were manually created.
    Rather than use this directly, consider using `createSerial()`.
    */
    case Serial(rawQueue: dispatch_queue_t)
    
    /**
    A custom concurrent queue.  Useful for wrapping your own queue's that were manually created.
    Rather than use this directly, consider using `createConcurrent()`.
    */
    case Concurrent(rawQueue: dispatch_queue_t)

    /**
    Returns a new serial queue with the specified lable (for debugging/crash reporting).

    - parameter label: The queue's identifying label.
    - parameter targetQueue: The target queue.  Default is "nil", aka .Default
    - returns: A DispatchQueue with a .Serial value.

    By default all private queues point to the default global queue (.Default).  You can specify
    a target queue to make a queue heirarchy and further set priority, etc.
    
    Note: when specifying a value for label, the app bundle is automatically queried, thus a value
    of `"mylabel"` results in `"com.mycompany.mylabel"` when seen in a debugger or crash log.
    */
    public static func createSerial(label: String, targetQueue: DispatchQueue? = nil) -> DispatchQueue {
        let queue = DispatchQueue.customQueue(label, concurrent: false, targetQueue: targetQueue)
        return queue
    }
    
    /**
    Returns a new concurrent queue with the specified lable (for debugging/crash reporting).
    
    - parameter label: The queue's identifying label.
    - parameter targetQueue: The target queue.  Default is "nil", aka .Default
    - returns: A DispatchQueue with a .Serial value.
    
    By default all private queues point to the default global queue (.Default).  You can specify
    a target queue to make a queue heirarchy and further set priority, etc.
    
    Note: when specifying a value for label, the app bundle is automatically queried, thus a value
    of `"mylabel"` results in `"com.mycompany.mylabel"` when seen in a debugger or crash log.
    */
    public static func createConcurrent(label: String, targetQueue: DispatchQueue? = nil) -> DispatchQueue {
        let queue = DispatchQueue.customQueue(label, concurrent: true, targetQueue: targetQueue)
        return queue
    }
    
    /**
    Returns a raw dispatch_queue_t that represents this queue.
    
    - returns: A raw dispatch_queue_t.
    */
    public func dispatchQueue() -> dispatch_queue_t {
        // we need to store these into a rawObject private var so we don't run
        // the risk to creating multiple queues for serial and concurrent.
        switch self {
            
        case .Main:
            return dispatch_get_main_queue()
            
        case .Background:
            return dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)

        case .UserInteractive:
            return dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)
        
        case .UserInitiated:
            return dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)
        
        case .Default:
            return dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0)
        
        case .Utility:
            return dispatch_get_global_queue(QOS_CLASS_UTILITY, 0)
            
        case .High:
            return dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)
            
        case .Low:
            return dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)
            
        case .Serial(let rawObject):
            return rawObject
            
        case .Concurrent(let rawObject):
            return rawObject
        }
    }
    
    private static func customQueue(label: String, concurrent: Bool, targetQueue: DispatchQueue?) -> DispatchQueue {
        let bundle = NSBundle(forClass: THGDispatch.self)
        let id = (bundle.reverseBundleIdentifier() ?? "") + "." + label

        let rawQueue: dispatch_queue_t = dispatch_queue_create(id, (concurrent ? DISPATCH_QUEUE_CONCURRENT : DISPATCH_QUEUE_SERIAL))
        let queue = (concurrent ? DispatchQueue.Concurrent(rawQueue: rawQueue) : DispatchQueue.Serial(rawQueue: rawQueue))
        
        if let targetQueue = targetQueue {
            dispatch_set_target_queue(rawQueue, targetQueue.dispatchQueue())
        }
        
        return queue
    }
}

public class THGDispatch {
    init() {
        // using this because i want this thing to cry bloody murder if it's instantiated.
        assertionFailure("Do not instantiate THGDispatch!")
    }
}
