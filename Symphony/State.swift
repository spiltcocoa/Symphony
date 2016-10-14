//
//  State.swift
//  Symphony
//
//  Created by Jeff Boek on 1/7/16.
//  Copyright © 2016 Spilt Cocoa. All rights reserved.
//

public protocol StateType {
    func canTransitionToState(_ state: Self) -> Bool
}

public protocol Stateable: class {
    associatedtype State: StateType
    var currentState: State { get set }

    func didTransitionFromState(_ state: State, toState: State)
}

public extension Stateable {
    func transitionToState(_ state: State) {
        guard currentState.canTransitionToState(state) else { return }
        let oldState = currentState
        currentState = state
        didTransitionFromState(oldState, toState: currentState)
    }
}

