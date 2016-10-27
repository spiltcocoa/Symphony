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
    enum State: StateProtocol {
        case none

        func canTransition(to state: State) -> Bool {
            switch(self, state) {
            case(.none, .none): return true
            }
        }
    }

    func didTransition(from oldState: State, to newState: State) {
        
    }
}

extension MainComposer: EventProtocol {
    enum Event: EventProtocol {
        case logout
    }
}
