//
//  DispatchSemaphore.swift
//  THGDispatch
//
//  Created by Steven W. Riggins on 2/16/15.
//  Copyright (c) 2015 Walmart. All rights reserved.
//

import Foundation

public struct DispatchSemaphore {
    
    public init (initialValue: Int) {
        rawObject = dispatch_semaphore_create(initialValue)
    }
    
    public func wait () {
        dispatch_semaphore_wait(rawObject, DISPATCH_TIME_FOREVER)
    }
    
    public func signal () {
        dispatch_semaphore_signal(rawObject)
    }
    
    private let rawObject: dispatch_semaphore_t
}