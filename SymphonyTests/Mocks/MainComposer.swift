//
//  MainComposer.swift
//  Symphony
//
//  Created by Jeff Boek on 1/7/16.
//  Copyright © 2016 Spilt Cocoa. All rights reserved.
//

import Symphony

class MainComposer: Composer {
    lazy var containerViewController = ParentViewController()
    var currentComposable: Composable? = nil
    var currentState: State = .None
}

extension MainComposer: Stateable {
    enum State: StateType {
        case None

        func canTransitionToState(state: State) -> Bool {
            switch(self, state) {
            case(.None, .None): return true
            }
        }
    }

    func didTransitionFromState(state: State, toState: State) {
        
    }
}

extension MainComposer: EventType {
    enum Event: EventType {
        case Logout
    }
}
