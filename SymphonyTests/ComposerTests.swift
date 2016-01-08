//
//  ComposerTests.swift
//  Symphony
//
//  Created by Jeff Boek on 12/31/15.
//  Copyright © 2015 Spilt Cocoa. All rights reserved.
//

import XCTest
@testable import Symphony

class ComposerTests: XCTestCase {

    func testThatContainerViewControllerShowsComposable() {
        // given
        let applicationComposer = ApplicationComposer()
        let loginComposer = LoginComposer()

        // when
        applicationComposer.showComposable(loginComposer)

        // then
        XCTAssert(applicationComposer.currentComposable === loginComposer)
    }

}
