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
        applicationComposer.transitionToState(.main)

        // then
        XCTAssertTrue(applicationComposer.currentState == .main)
    }

    func testThatItSendsSuccessMessage() {
        // given
        let applicationComposer = ApplicationComposer()

        // when
        applicationComposer.transitionToState(.main)

        // then
        XCTAssertTrue(applicationComposer.receivedStateMessage)
    }

    func testThatItChecksIfItCanTransition() {
        // given
        let composer = ApplicationComposer()

        // when
        let validTransition = composer.currentState.canTransitionToState(.main)
        let invalidTransition = composer.currentState.canTransitionToState(.logout)

        // then
        XCTAssertTrue(validTransition)
        XCTAssertFalse(invalidTransition)
    }
}
