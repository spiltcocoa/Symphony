//
//  State.swift
//  Symphony
//
//  Created by Jeff Boek on 1/7/16.
//  Copyright © 2016 Spilt Cocoa. All rights reserved.
//

public protocol StateProtocol {
    func canTransition(to state: Self) -> Bool
}

public protocol Stateable: class {
    associatedtype State: StateProtocol
    var currentState: State { get set }

    func didTransition(from oldState: State, to newState: State)
}

public extension Stateable {
    func transition(to state: State) {
        guard currentState.canTransition(to: state) else { return }
        let oldState = currentState
        currentState = state
        didTransition(from: oldState, to: currentState)
    }
}

