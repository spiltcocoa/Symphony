//
//  ComposerTests.swift
//  Symphony
//
//  Created by Jeff Boek on 12/31/15.
//  Copyright © 2015 Spilt Cocoa. All rights reserved.
//

import XCTest
import Symphony

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

class ParentComposer: XCTestCase {

    let composer = GenericComposer<ParentViewController>()

    func test_whenShows_isShowing() {
        let composable = BasicComposable()

        composer.showComposable(composable)

        let currentlyShown = composer.containerViewController.childViewController
        XCTAssert(currentlyShown === composable.viewController)
    }

    func test_whenShows_childIsRetained() {
        weak var weakComposable: BasicComposable?

        autoreleasepool {
            let composable = BasicComposable()
            weakComposable = composable
            composer.showComposable(composable)
        }

        XCTAssertNotNil(weakComposable)
    }

    func test_whenShows_oldChildIsReleased() {
        weak var weakOldComposable: BasicComposable?
        weak var weakNewComposable: BasicComposable?

        autoreleasepool {
            let oldComposable = BasicComposable()
            let newComposable = BasicComposable()
            weakOldComposable = oldComposable
            weakNewComposable = newComposable
            composer.showComposable(oldComposable)
            composer.showComposable(newComposable)
        }

        XCTAssertNil(weakOldComposable)
        XCTAssertNotNil(weakNewComposable)
    }


    func test_whenPresents_childAndPresentedAreBothRetained() {
        weak var weakChildComposable: BasicComposable?
        weak var weakPresentedComposable: BasicComposable?

        autoreleasepool {
            let childComposable = BasicComposable()
            let presentedComposable = BasicComposable()
            weakChildComposable = childComposable
            weakPresentedComposable = presentedComposable
            composer.showComposable(childComposable)
            composer.presentComposable(presentedComposable)
        }

        XCTAssertNotNil(weakChildComposable)
        XCTAssertNotNil(weakPresentedComposable)
    }

    func test_whenShowingWhilePresenting_newChildAndPresentedAreRetained_oldChildIsReleased() {
        weak var weakOldChildComposable: BasicComposable?
        weak var weakNewChildComposable: BasicComposable?
        weak var weakPresentedComposable: BasicComposable?

        autoreleasepool {
            let oldChildComposable = BasicComposable()
            let newChildComposable = BasicComposable()
            let presentedComposable = BasicComposable()
            weakOldChildComposable = oldChildComposable
            weakNewChildComposable = newChildComposable
            weakPresentedComposable = presentedComposable
            composer.showComposable(oldChildComposable)
            composer.presentComposable(presentedComposable)
            composer.showComposable(newChildComposable)
        }

        XCTAssertNil(weakOldChildComposable)
        XCTAssertNotNil(weakNewChildComposable)

        // TODO: We need to find a way to host a UIWindow, otherwise we can't test this
//        XCTAssertNotNil(weakPresentedComposable)
    }
}


class NavigationComposerTests: XCTestCase {

    let composer = GenericComposer<UINavigationController>()

    func test_whenPushes_isShowingPushed() {
        let composable = BasicComposable()

        composer.pushComposable(composable)

        let currentlyShown = composer.containerViewController.viewControllers.last
        XCTAssert(currentlyShown === composable.viewController)
    }

    func test_whenPushes_childIsRetained() {
        weak var weakComposable: BasicComposable?

        autoreleasepool {
            let composable = BasicComposable()
            weakComposable = composable
            composer.pushComposable(composable)
        }

        XCTAssertNotNil(weakComposable)
    }

    func test_whenPushesMultiple_allChildrenAreRetained() {
        weak var weakFirstComposable: BasicComposable?
        weak var weakSecondComposable: BasicComposable?
        weak var weakThirdComposable: BasicComposable?

        autoreleasepool {
            let firstComposable = BasicComposable()
            let secondComposable = BasicComposable()
            let thirdComposable = BasicComposable()
            weakFirstComposable = firstComposable
            weakSecondComposable = secondComposable
            weakThirdComposable = thirdComposable
            composer.pushComposable(firstComposable)
            composer.pushComposable(secondComposable)
            composer.pushComposable(thirdComposable)
        }

        XCTAssertNotNil(weakFirstComposable)
        XCTAssertNotNil(weakSecondComposable)
        XCTAssertNotNil(weakThirdComposable)
    }

    func test_whenPresents_childrenAndPresentedAreBothRetained() {
        weak var weakChildComposable: BasicComposable?
        weak var weakPresentedComposable: BasicComposable?

        autoreleasepool {
            let childComposable = BasicComposable()
            let presentedComposable = BasicComposable()
            weakChildComposable = childComposable
            weakPresentedComposable = presentedComposable
            composer.pushComposable(childComposable)
            composer.presentComposable(presentedComposable)
        }

        XCTAssertNotNil(weakChildComposable)
        XCTAssertNotNil(weakPresentedComposable)
    }

    func test_whenPushesWhilePresenting_allChildrenAndPresentedAreRetained() {
        weak var weakFirstChildComposable: BasicComposable?
        weak var weakSecondChildComposable: BasicComposable?
        weak var weakPresentedComposable: BasicComposable?

        autoreleasepool {
            let firstChildComposable = BasicComposable()
            let secondChildComposable = BasicComposable()
            let presentedComposable = BasicComposable()
            weakFirstChildComposable = firstChildComposable
            weakSecondChildComposable = secondChildComposable
            weakPresentedComposable = presentedComposable
            composer.pushComposable(firstChildComposable)
            composer.presentComposable(presentedComposable)
            composer.pushComposable(secondChildComposable)
        }

        XCTAssertNotNil(weakFirstChildComposable)
        XCTAssertNotNil(weakSecondChildComposable)
        XCTAssertNotNil(weakPresentedComposable)
    }
}
