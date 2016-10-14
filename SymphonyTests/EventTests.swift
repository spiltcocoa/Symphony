//
//  EventTests.swift
//  Symphony
//
//  Created by Jeff Boek on 1/7/16.
//  Copyright © 2016 Spilt Cocoa. All rights reserved.
//

import XCTest
@testable import Symphony

class EventTests: XCTestCase {
    func testThatICanReceiveAnEvent() {
        // given
        let applicationComposer = ApplicationComposer()
        applicationComposer.start()
        guard let loginComposer = applicationComposer.currentComposables.first as? LoginComposer else {
            XCTFail()
            return
        }

        // when
        loginComposer.transitionToState(.Finished)

        // then
        XCTAssertTrue(applicationComposer.receivedEvent)
    }
}
