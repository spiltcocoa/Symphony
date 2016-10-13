//
//  LoginComposer.swift
//  Symphony
//
//  Created by Jeff Boek on 1/7/16.
//  Copyright © 2016 Spilt Cocoa. All rights reserved.
//

import Symphony

class LoginComposer: ComposerType {
    lazy var container = ParentViewController()
    var currentComposable: Composable? = nil
    var currentState: State = .Main
    var eventListener: (Event -> Void)? = nil
}

extension LoginComposer: Composable {
    var viewController: UIViewController { return container }
}

extension LoginComposer: Stateable {
    enum State: StateType {
        case Main
        case Finished

        func canTransitionToState(state: State) -> Bool {
            switch(self, state) {
            case(.Main, .Finished): return true
            default: return false
            }
        }
    }

    func didTransitionFromState(state: State, toState: State) {
        eventListener?(.Finished)
    }
}

extension LoginComposer: Eventable {
    enum Event: EventType {
        case Finished
    }
}
