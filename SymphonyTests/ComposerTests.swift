//
//  ComposerTests.swift
//  Symphony
//
//  Created by Jeff Boek on 12/31/15.
//  Copyright © 2015 Spilt Cocoa. All rights reserved.
//

import XCTest
@testable import Symphony

class GenericComposer<Container: UIViewController>: Composer {
    typealias ContainerViewController = Container
    let containerViewController = Container()
    var currentComposables: [Composable] = []
}

// We can't use a `ViewController: Composable` for these, because the VC stack
// handles it's own memory management.
class BasicComposable: Composable { let viewController = UIViewController() }

class UIComposer: XCTestCase {

    let composer = GenericComposer<UIViewController>()

    func xtest_whenPresents_isPresenting() {
        let composable = BasicComposable()

        composer.presentComposable(composable)

        // Can't currently test because I don't know how to put the composer into a window heirarchy
        // let currentlyPresented = composer.containerViewController.presentedViewController
        // XCTAssert(currentlyPresented === composable.viewController)
    }

    func test_whenPresents_presentedIsRetained() {
        weak var weakComposable: BasicComposable?

        autoreleasepool {
            let composable = BasicComposable()
            weakComposable = composable
            composer.presentComposable(composable)
        }

        XCTAssertNotNil(weakComposable)
    }

    func xtest_whenDismisses_presentedIsReleased() {
        weak var weakComposable: BasicComposable?

        autoreleasepool {
            let composable = BasicComposable()
            weakComposable = composable
            composer.presentComposable(composable)
        }
        composer.dismissComposableAnimated()

        // Need to figure out the window heirarchy to test this too, since we can't
        // figure out which composable to release if there's no `presentedViewController`
        XCTAssertNil(weakComposable)
    }
}
