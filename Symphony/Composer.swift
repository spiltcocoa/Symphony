//
//  Composer.swift
//  Symphony
//
//  Created by Jeff Boek on 12/31/15.
//  Copyright © 2015 Spilt Cocoa. All rights reserved.
//

import UIKit

/// A type that manages the presentation of one or many Composables
public protocol Composer: class {

    /// The ViewController type that the composer will use to contain
    /// and present the viewControllers of it's children
    associatedtype ContainerViewController: UIViewController

    /// The viewController instance that the composer will use to contain
    /// and present the viewControllers of it's children
    var containerViewController: ContainerViewController { get }

    /// A reference to the currently presented composable.
    /// This is generally only necissary for memory management,
    /// and shouldn't need to be messed with.
    var currentComposables: [Composable] { get set }
}

// MARK: - Convenience API for Composers using UIKit `UIViewController`s

public extension Composer where ContainerViewController: UIViewController {

    public func present(_ composable: Composable, animated: Bool = false) {
        currentComposables.append(composable)
        containerViewController.present(composable.viewController, animated: animated, completion: nil)
    }

    public func dismissComposable(animated: Bool = false) {
        guard let presentedVC = containerViewController.presentedViewController else { return }
        currentComposables = currentComposables.filter { $0.viewController !== presentedVC }
        containerViewController.dismiss(animated: animated, completion: nil)
    }
}

public extension Composer where ContainerViewController: UINavigationController {

    public func push(_ composable: Composable, animated: Bool = false) {
        currentComposables.append(composable)
        containerViewController.pushViewController(composable.viewController, animated: animated)
    }

    public func popComposable(animated: Bool = false) {
        guard let poppingVC = containerViewController.viewControllers.last else { return }
        currentComposables = currentComposables.filter { $0.viewController !== poppingVC }
        containerViewController.popViewController(animated: animated)
    }

    public func set(_ composables: [Composable], animated: Bool = false) {
        currentComposables = currentComposables.filter {
            $0.viewController === containerViewController.presentedViewController
        }
        currentComposables += composables
        containerViewController.setViewControllers(composables.map { $0.viewController }, animated: animated)
    }
}
