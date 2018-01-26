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

    var preTestRootViewController: UIViewController?

    override func setUp() {
        super.setUp()
        guard let window = UIApplication.shared.keyWindow else { XCTFail(); return }
        preTestRootViewController = window.rootViewController
        window.rootViewController = composer.containerViewController
    }

    override func tearDown() {
        super.tearDown()
        UIApplication.shared.keyWindow?.rootViewController = preTestRootViewController
    }

    func test_whenPresents_isPresenting() {
        let presentedComposable = BasicComposable()

        composer.present(presentedComposable)

        let currentlyPresented = composer.containerViewController.presentedViewController
        XCTAssert(currentlyPresented === presentedComposable.viewController)
    }

    func test_whenPresents_presentedIsRetained() {
        weak var weakPresentedComposable: BasicComposable?

        autoreleasepool {
            let presentedComposable = BasicComposable()
            weakPresentedComposable = presentedComposable
            composer.present(presentedComposable)
        }

        XCTAssertNotNil(weakPresentedComposable)
    }

    func test_whenDismisses_presentedIsReleased() {
        weak var weakPresentedComposable: BasicComposable?

        autoreleasepool {
            let presentedComposable = BasicComposable()
            weakPresentedComposable = presentedComposable
            composer.present(presentedComposable)
        }
        composer.dismissComposable()

        XCTAssertNil(weakPresentedComposable)
    }
}

class ParentComposer: XCTestCase {

    let composer = GenericComposer<ParentViewController>()

    var preTestRootViewController: UIViewController?

    override func setUp() {
        super.setUp()
        guard let window = UIApplication.shared.keyWindow else { XCTFail(); return }
        preTestRootViewController = window.rootViewController
        window.rootViewController = composer.containerViewController
    }

    override func tearDown() {
        super.tearDown()
        UIApplication.shared.keyWindow?.rootViewController = preTestRootViewController
    }

    func test_whenShows_isShowing() {
        let shownComposable = BasicComposable()

        composer.display(shownComposable)

        let currentlyShown = composer.containerViewController.displayedViewController
        XCTAssert(currentlyShown === shownComposable.viewController)
    }

    func test_whenShows_shownIsRetained() {
        weak var weakShownComposable: BasicComposable?

        autoreleasepool {
            let shownComposable = BasicComposable()
            weakShownComposable = shownComposable
            composer.display(shownComposable)
        }

        XCTAssertNotNil(weakShownComposable)
    }

    func test_whenShows_oldShownIsReleased() {
        weak var weakOldShownComposable: BasicComposable?
        weak var weakNewShownComposable: BasicComposable?

        autoreleasepool {
            let oldShownComposable = BasicComposable()
            let newShownComposable = BasicComposable()
            weakOldShownComposable = oldShownComposable
            weakNewShownComposable = newShownComposable
            composer.display(oldShownComposable)
            composer.display(newShownComposable)
        }

        XCTAssertNil(weakOldShownComposable)
        XCTAssertNotNil(weakNewShownComposable)
    }


    func test_whenPresents_shownAndPresentedAreBothRetained() {
        weak var weakShownComposable: BasicComposable?
        weak var weakPresentedComposable: BasicComposable?

        autoreleasepool {
            let shownComposable = BasicComposable()
            let presentedComposable = BasicComposable()
            weakShownComposable = shownComposable
            weakPresentedComposable = presentedComposable
            composer.display(shownComposable)
            composer.present(presentedComposable)
        }

        XCTAssertNotNil(weakShownComposable)
        XCTAssertNotNil(weakPresentedComposable)
    }

    func test_whenShowingWhilePresenting_newShownAndPresentedAreRetained_oldShownIsReleased() {
        weak var weakOldShownComposable: BasicComposable?
        weak var weakNewShownComposable: BasicComposable?
        weak var weakPresentedComposable: BasicComposable?

        autoreleasepool {
            let oldShownComposable = BasicComposable()
            let newShownComposable = BasicComposable()
            let presentedComposable = BasicComposable()
            weakOldShownComposable = oldShownComposable
            weakNewShownComposable = newShownComposable
            weakPresentedComposable = presentedComposable
            composer.display(oldShownComposable)
            composer.present(presentedComposable)
            composer.display(newShownComposable)
        }

        XCTAssertNil(weakOldShownComposable)
        XCTAssertNotNil(weakNewShownComposable)
        XCTAssertNotNil(weakPresentedComposable)
    }
}


class NavigationComposerTests: XCTestCase {

    let composer = GenericComposer<UINavigationController>()

    var preTestRootViewController: UIViewController?

    override func setUp() {
        super.setUp()
        guard let window = UIApplication.shared.keyWindow else { XCTFail(); return }
        preTestRootViewController = window.rootViewController
        window.rootViewController = composer.containerViewController
    }

    override func tearDown() {
        super.tearDown()
        UIApplication.shared.keyWindow?.rootViewController = preTestRootViewController
    }

    func test_whenPushes_isShowingPushed() {
        let pushedComposable = BasicComposable()

        composer.push(pushedComposable)

        let currentlyShown = composer.containerViewController.viewControllers.last
        XCTAssert(currentlyShown === pushedComposable.viewController)
    }

    func test_whenPushes_pushedIsRetained() {
        weak var weakPushedComposable: BasicComposable?

        autoreleasepool {
            let pushedComposable = BasicComposable()
            weakPushedComposable = pushedComposable
            composer.push(pushedComposable)
        }

        XCTAssertNotNil(weakPushedComposable)
    }

    func test_whenPresentingMultipleModals_presentingDoesNotCauseACrash() {

        let presentedComposable1 = BasicComposable()
        let presentedComposable2 = BasicComposable()

        composer.present(presentedComposable1)
        composer.present(presentedComposable2)

        XCTAssert(presentedComposable1.viewController.presentedViewController === presentedComposable2)
    }

    func test_whenPushesMultiple_allPushedAreRetained() {
        weak var weakFirstPushedComposable: BasicComposable?
        weak var weakSecondPushedComposable: BasicComposable?
        weak var weakThirdPushedComposable: BasicComposable?

        autoreleasepool {
            let firstPushedComposable = BasicComposable()
            let secondPushedComposable = BasicComposable()
            let thirdPushedComposable = BasicComposable()
            weakFirstPushedComposable = firstPushedComposable
            weakSecondPushedComposable = secondPushedComposable
            weakThirdPushedComposable = thirdPushedComposable
            composer.push(firstPushedComposable)
            composer.push(secondPushedComposable)
            composer.push(thirdPushedComposable)
        }

        XCTAssertNotNil(weakFirstPushedComposable)
        XCTAssertNotNil(weakSecondPushedComposable)
        XCTAssertNotNil(weakThirdPushedComposable)
    }

    func test_whenPresents_childrenAndPresentedAreBothRetained() {
        weak var weakShownComposable: BasicComposable?
        weak var weakPresentedComposable: BasicComposable?

        autoreleasepool {
            let shownComposable = BasicComposable()
            let presentedComposable = BasicComposable()
            weakShownComposable = shownComposable
            weakPresentedComposable = presentedComposable
            composer.push(shownComposable)
            composer.present(presentedComposable)
        }

        XCTAssertNotNil(weakShownComposable)
        XCTAssertNotNil(weakPresentedComposable)
    }

    func test_whenPushesWhilePresenting_allChildrenAndPresentedAreRetained() {
        weak var weakFirstShownComposable: BasicComposable?
        weak var weakSecondShownComposable: BasicComposable?
        weak var weakPresentedComposable: BasicComposable?

        autoreleasepool {
            let firstShownComposable = BasicComposable()
            let secondShownComposable = BasicComposable()
            let presentedComposable = BasicComposable()
            weakFirstShownComposable = firstShownComposable
            weakSecondShownComposable = secondShownComposable
            weakPresentedComposable = presentedComposable
            composer.push(firstShownComposable)
            composer.present(presentedComposable)
            composer.push(secondShownComposable)
        }

        XCTAssertNotNil(weakFirstShownComposable)
        XCTAssertNotNil(weakSecondShownComposable)
        XCTAssertNotNil(weakPresentedComposable)
    }

    func test_whenPops_poppedIsReleased_allRemainingAreRetained() {
        weak var weakFirstPushedComposable: BasicComposable?
        weak var weakSecondPushedComposable: BasicComposable?
        weak var weakThirdPushedComposable: BasicComposable?

        autoreleasepool {
            let firstPushedComposable = BasicComposable()
            let secondPushedComposable = BasicComposable()
            let thirdPushedComposable = BasicComposable()
            weakFirstPushedComposable = firstPushedComposable
            weakSecondPushedComposable = secondPushedComposable
            weakThirdPushedComposable = thirdPushedComposable
            composer.push(firstPushedComposable)
            composer.push(secondPushedComposable)
            composer.push(thirdPushedComposable)
            composer.popComposable()
        }

        XCTAssertNotNil(weakFirstPushedComposable)
        XCTAssertNotNil(weakSecondPushedComposable)
        XCTAssertNil(weakThirdPushedComposable)
    }

    func test_whenPopsWhilePresenting_poppedIsReleased_allRemainingAreRetained() {
        weak var weakFirstPushedComposable: BasicComposable?
        weak var weakSecondPushedComposable: BasicComposable?
        weak var weakThirdPushedComposable: BasicComposable?
        weak var weakPresentedComposable: BasicComposable?

        autoreleasepool {
            let firstPushedComposable = BasicComposable()
            let secondPushedComposable = BasicComposable()
            let thirdPushedComposable = BasicComposable()
            let presentedComposable = BasicComposable()
            weakFirstPushedComposable = firstPushedComposable
            weakSecondPushedComposable = secondPushedComposable
            weakThirdPushedComposable = thirdPushedComposable
            weakPresentedComposable = presentedComposable
            composer.push(firstPushedComposable)
            composer.push(secondPushedComposable)
            composer.push(thirdPushedComposable)
            composer.present(presentedComposable)
            composer.popComposable()
        }

        XCTAssertNotNil(weakFirstPushedComposable)
        XCTAssertNotNil(weakSecondPushedComposable)
        XCTAssertNotNil(weakPresentedComposable)
        XCTAssertNil(weakThirdPushedComposable)
    }

    func test_whenSetting_newSetAreRetained() {
        weak var weakFirstSetComposable: BasicComposable?
        weak var weakSecondSetComposable: BasicComposable?

        autoreleasepool {
            let firstSetComposable = BasicComposable()
            let secondSetComposable = BasicComposable()
            weakFirstSetComposable = firstSetComposable
            weakSecondSetComposable = secondSetComposable
            composer.set([firstSetComposable, secondSetComposable])
        }

        XCTAssertNotNil(weakFirstSetComposable)
        XCTAssertNotNil(weakSecondSetComposable)
    }

    func test_whenSetting_oldSetAreReleased_newSetAreRetained() {
        weak var weakOldFirstSetComposable: BasicComposable?
        weak var weakOldSecondSetComposable: BasicComposable?
        weak var weakNewFirstSetComposable: BasicComposable?
        weak var weakNewSecondSetComposable: BasicComposable?

        autoreleasepool {
            let oldFirstSetComposable = BasicComposable()
            let oldSecondSetComposable = BasicComposable()
            let newFirstSetComposable = BasicComposable()
            let newSecondSetComposable = BasicComposable()
            weakOldFirstSetComposable = oldFirstSetComposable
            weakOldSecondSetComposable = oldSecondSetComposable
            weakNewFirstSetComposable = newFirstSetComposable
            weakNewSecondSetComposable = newSecondSetComposable
            composer.set([oldFirstSetComposable, oldSecondSetComposable])
            composer.set([newFirstSetComposable, newSecondSetComposable])
        }

        XCTAssertNil(weakOldFirstSetComposable)
        XCTAssertNil(weakOldSecondSetComposable)
        XCTAssertNotNil(weakNewFirstSetComposable)
        XCTAssertNotNil(weakNewSecondSetComposable)
    }

    func test_whenSettingWhilePresenting_oldSetAreReleased_newSetAndPresentedAreRetained() {
        weak var weakOldFirstSetComposable: BasicComposable?
        weak var weakOldSecondSetComposable: BasicComposable?
        weak var weakNewFirstSetComposable: BasicComposable?
        weak var weakNewSecondSetComposable: BasicComposable?
        weak var weakPresentedComposable: BasicComposable?

        autoreleasepool {
            let oldFirstSetComposable = BasicComposable()
            let oldSecondSetComposable = BasicComposable()
            let newFirstSetComposable = BasicComposable()
            let newSecondSetComposable = BasicComposable()
            let presentedComposable = BasicComposable()
            weakOldFirstSetComposable = oldFirstSetComposable
            weakOldSecondSetComposable = oldSecondSetComposable
            weakNewFirstSetComposable = newFirstSetComposable
            weakNewSecondSetComposable = newSecondSetComposable
            weakPresentedComposable = presentedComposable
            composer.set([oldFirstSetComposable, oldSecondSetComposable])
            composer.present(presentedComposable)
            composer.set([newFirstSetComposable, newSecondSetComposable])
        }

        XCTAssertNil(weakOldFirstSetComposable)
        XCTAssertNil(weakOldSecondSetComposable)
        XCTAssertNotNil(weakNewFirstSetComposable)
        XCTAssertNotNil(weakNewSecondSetComposable)
        XCTAssertNotNil(weakPresentedComposable)
    }
}
