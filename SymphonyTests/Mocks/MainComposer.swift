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
    var currentComposables: [Composable] = []
    var currentState: State = .none
}

extension MainComposer: Stateable {
    enum State: StateType {
        case none

        func canTransitionToState(_ state: State) -> Bool {
            switch(self, state) {
            case(.none, .none): return true
            }
        }
    }

    func didTransitionFromState(_ state: State, toState: State) {
        
    }
}

extension MainComposer: EventType {
    enum Event: EventType {
        case logout
    }
}
