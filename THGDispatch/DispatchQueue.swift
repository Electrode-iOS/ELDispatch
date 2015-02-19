//
//  DispatchQueue.swift
//  THGDispatch
//
//  Created by Brandon Sneed on 2/10/15.
//  Copyright (c) 2015 TheHolyGrail. All rights reserved.
//

import Foundation
import THGFoundation

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
    case Custom(rawQueue: dispatch_queue_t)

    public static func createSerial(label: String, targetQueue: DispatchQueue? = nil) -> DispatchQueue {
        let queue = DispatchQueue.customQueue(label, concurrent: false, targetQueue: targetQueue)
        return queue
    }
    
    public static func createConcurrent(label: String, targetQueue: DispatchQueue? = nil) -> DispatchQueue {
        let queue = DispatchQueue.customQueue(label, concurrent: true, targetQueue: targetQueue)
        return queue
    }
    
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
            
        case .Custom(let rawObject):
            return rawObject
        }
    }
    
    private static func customQueue(label: String, concurrent: Bool, targetQueue: DispatchQueue?) -> DispatchQueue {
        let bundle = NSBundle(forClass: THGDispatch.self)
        let id = (bundle.reverseBundleIdentifier() ?? "") + "." + label

        let rawQueue: dispatch_queue_t = dispatch_queue_create(id, (concurrent ? DISPATCH_QUEUE_CONCURRENT : DISPATCH_QUEUE_SERIAL))
        let queue = DispatchQueue.Custom(rawQueue: rawQueue)
        
        if let target = targetQueue {
            dispatch_set_target_queue(rawQueue, targetQueue?.dispatchQueue())
        }
        
        return queue
    }
}

@objc public class THGDispatch {
    init() {
        assertionFailure("Do not instantiate this!")
    }
}
