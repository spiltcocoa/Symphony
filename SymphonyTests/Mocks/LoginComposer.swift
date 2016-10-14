//
//  LoginComposer.swift
//  Symphony
//
//  Created by Jeff Boek on 1/7/16.
//  Copyright © 2016 Spilt Cocoa. All rights reserved.
//

import Symphony

class LoginComposer: Composer, Composable {
    lazy var containerViewController = ParentViewController()
    var currentComposables: [Composable] = []
    var currentState: State = .main
    var eventListener: ((Event) -> Void)? = nil
}

extension LoginComposer: Stateable {
    enum State: StateType {
        case main
        case finished

        func canTransitionToState(_ state: State) -> Bool {
            switch(self, state) {
            case(.main, .finished): return true
            default: return false
            }
        }
    }

    func didTransitionFromState(_ state: State, toState: State) {
        eventListener?(.finished)
    }
}

extension LoginComposer: Eventable {
    enum Event: EventType {
        case finished
    }
}
