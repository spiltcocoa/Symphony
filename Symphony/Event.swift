//
//  Event.swift
//  Symphony
//
//  Created by Jeff Boek on 1/7/16.
//  Copyright © 2016 Spilt Cocoa. All rights reserved.
//


public protocol EventProtocol {}

public protocol Eventable {
    associatedtype Event: EventProtocol
    associatedtype ListenerType = (Event) -> Void
    var eventListener: ListenerType? { get set }
}
