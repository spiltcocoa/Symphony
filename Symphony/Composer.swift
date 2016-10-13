//
//  Composer.swift
//  Symphony
//
//  Created by Jeff Boek on 12/31/15.
//  Copyright © 2015 Spilt Cocoa. All rights reserved.
//

import UIKit

public protocol Composable: class {
    var viewController: UIViewController { get }
}

public protocol ComposerType: class {
    associatedtype Container: ContainerType
    var container: Container { get }
    var currentComposable: Composable? { get set }
}



public extension ComposerType where Container: UIViewController {
    public func presentComposable(composable: Composable, animated: Bool = false) {
        currentComposable = composable
        container.presentViewController(composable.viewController, animated: animated, completion: nil)
    }

    public func dismissComposableAnimated(animated: Bool = false) {
        container.dismissViewControllerAnimated(animated, completion: nil)
    }
}

public extension ComposerType where Container: UINavigationController {
    public func pushComposable(composable: Composable, animated: Bool = false) {
        currentComposable = composable
        container.pushViewController(composable.viewController, animated: animated)
    }

    public func popComposable(animated: Bool = false) {
        container.popViewControllerAnimated(animated)
        //        currentComposable = container.viewControllers.last
    }

    public func setComposables(composables: [Composable], animated: Bool = false) {
        currentComposable = composables.last
        container.setViewControllers(composables.map { $0.viewController }, animated: animated)
    }
}

public extension ComposerType where Container: ContainerViewController {
    public func showComposable(composable: Composable) {
        currentComposable = composable
        container.showViewController(composable.viewController)
    }
}
