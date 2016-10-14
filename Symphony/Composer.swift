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
    associatedtype ContainerViewController: UIViewController
    var containerViewController: ContainerViewController { get }
    var currentComposable: Composable? { get set }
}



public extension ComposerType where ContainerViewController: UIViewController {
    public func presentComposable(composable: Composable, animated: Bool = false) {
        currentComposable = composable
        containerViewController.presentViewController(composable.viewController, animated: animated, completion: nil)
    }

    public func dismissComposableAnimated(animated: Bool = false) {
        containerViewController.dismissViewControllerAnimated(animated, completion: nil)
    }
}

public extension ComposerType where ContainerViewController: UINavigationController {
    public func pushComposable(composable: Composable, animated: Bool = false) {
        currentComposable = composable
        containerViewController.pushViewController(composable.viewController, animated: animated)
    }

    public func popComposable(animated: Bool = false) {
        containerViewController.popViewControllerAnimated(animated)
        //        currentComposable = container.viewControllers.last
    }

    public func setComposables(composables: [Composable], animated: Bool = false) {
        currentComposable = composables.last
        containerViewController.setViewControllers(composables.map { $0.viewController }, animated: animated)
    }
}

public extension ComposerType where ContainerViewController: ParentViewController {
    public func showComposable(composable: Composable) {
        currentComposable = composable
        containerViewController.showViewController(composable.viewController)
    }
}
