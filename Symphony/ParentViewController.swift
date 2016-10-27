//
//  ParentViewController.swift
//  Symphony
//
//  Created by Jeff Boek on 1/7/16.
//  Copyright © 2016 Spilt Cocoa. All rights reserved.
//

// A completely unadorned viewController container.
// i.e. no TabBar, NavigationBar, etc.. It just hot swaps children.
// Easy to swap other ViewControllers into with state changes.
public final class ParentViewController: UIViewController {

    // MARK: - Properties
    public fileprivate(set) var displayedViewController: UIViewController?

    // MARK: - Init
    public convenience init() {
        self.init(nibName: nil, bundle: nil)
    }

    // MARK: - ViewContoller Containment
    override public var childViewControllerForStatusBarStyle : UIViewController? {
        return displayedViewController
    }

    public func display(viewController: UIViewController) {
        if let existingVC = displayedViewController {
            existingVC.willMove(toParentViewController: nil)
            existingVC.view.removeFromSuperview()
            existingVC.removeFromParentViewController()
        }

        displayedViewController = viewController
        addChildViewController(viewController)
        viewController.view.frame = view.bounds
        view.addSubview(viewController.view)
        viewController.didMove(toParentViewController: self)
        setNeedsStatusBarAppearanceUpdate()
    }
}

public extension Composer where ContainerViewController: ParentViewController {
    public func display(composable: Composable) {
        currentComposables = currentComposables.filter {
            $0.viewController === containerViewController.presentedViewController
        }
        currentComposables.append(composable)
        containerViewController.display(viewController: composable.viewController)
    }
}
