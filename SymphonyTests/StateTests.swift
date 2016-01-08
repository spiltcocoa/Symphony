//
//  StateTests.swift
//  Symphony
//
//  Created by Jeff Boek on 1/7/16.
//  Copyright © 2016 Spilt Cocoa. All rights reserved.
//

import XCTest
@testable import Symphony

class StateTests: XCTestCase {

    func testThatTheStateCanTransition() {
        // given
        let applicationComposer = ApplicationComposer()

        // when
        applicationComposer.transitionToState(.Main)

        // then
        XCTAssertTrue(applicationComposer.currentState == .Main)
    }

    func testThatItSendsSuccessMessage() {
        // given
        let applicationComposer = ApplicationComposer()

        // when
        applicationComposer.transitionToState(.Main)

        // then
        XCTAssertTrue(applicationComposer.receivedStateMessage)
    }

    func testThatItChecksIfItCanTransition() {
        // given
        let composer = ApplicationComposer()

        // when
        let validTransition = composer.currentState.canTransitionToState(.Main)
        let invalidTransition = composer.currentState.canTransitionToState(.Logout)

        // then
        XCTAssertTrue(validTransition)
        XCTAssertFalse(invalidTransition)
    }
}
