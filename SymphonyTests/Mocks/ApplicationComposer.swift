//
//  ApplicationComposer.swift
//  Symphony
//
//  Created by Jeff Boek on 1/7/16.
//  Copyright © 2016 Spilt Cocoa. All rights reserved.
//

import Symphony

class ApplicationComposer: Composer {
    lazy var containerViewController = ParentViewController()
    var currentComposables: [Composable] = []
    var currentState: State = .login
    var receivedStateMessage = false
    var receivedEvent = false

    func start() {
        display(loginComposable())
    }

    fileprivate func loginComposable() -> Composable {
        let composable = LoginComposer()
        composable.eventListener = onLoginEvent

        return composable
    }

    fileprivate func mainComposable() -> Composable {
        let composable = LoginComposer()
        composable.eventListener = onLoginEvent

        return composable
    }

    fileprivate func onLoginEvent(_ event: LoginComposer.Event) {
        receivedEvent = true
        
        switch event {
        case .finished: transition(to: .main)
        }
    }

    fileprivate func onMainEvent(_ event: MainComposer.Event) {
        print(event)
    }
}

extension ApplicationComposer: Stateable {
    enum State: StateProtocol {
        case login
        case loggedIn
        case main
        case logout

        func canTransition(to state: State) -> Bool {
            switch(self, state) {
            case(.login, .main): return true
            case(.login, .logout): return false
            default: return false
            }
        }
    }

    func didTransition(from oldState: State, to newState: State) {
        receivedStateMessage = true
    }
}
