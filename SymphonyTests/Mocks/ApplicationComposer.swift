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
    var currentComposable: Composable? = nil
    var currentState: State = .Login
    var receivedStateMessage = false
    var receivedEvent = false

    func start() {
        showComposable(loginComposable())
    }

    private func loginComposable() -> Composable {
        let composable = LoginComposer()
        composable.eventListener = onLoginEvent

        return composable
    }

    private func mainComposable() -> Composable {
        let composable = LoginComposer()
        composable.eventListener = onLoginEvent

        return composable
    }

    private func onLoginEvent(event: LoginComposer.Event) {
        receivedEvent = true
        
        switch event {
        case .Finished: transitionToState(.Main)
        }
    }

    private func onMainEvent(event: MainComposer.Event) {
        print(event)
    }
}

extension ApplicationComposer: Stateable {
    enum State: StateType {
        case Login
        case LoggedIn
        case Main
        case Logout

        func canTransitionToState(state: State) -> Bool {
            switch(self, state) {
            case(.Login, .Main): return true
            case(.Login, .Logout): return false
            default: return false
            }
        }
    }

    func didTransitionFromState(state: State, toState: State) {
        receivedStateMessage = true
    }
}
