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
public class ParentViewController: UIViewController {

    // MARK: - Properties
    public private(set) var childViewController: UIViewController?

    // MARK: - Init
    public convenience init() {
        self.init(nibName: nil, bundle: nil)
    }

    // MARK: - ViewContoller Containment
    override public func childViewControllerForStatusBarStyle() -> UIViewController? {
        return childViewController
    }

    func showViewController(viewController: UIViewController) {
        if let existingVC = childViewController {
            existingVC.willMoveToParentViewController(nil)
            existingVC.view.removeFromSuperview()
            existingVC.removeFromParentViewController()
        }

        childViewController = viewController
        addChildViewController(viewController)
        viewController.view.frame = view.bounds
        view.addSubview(viewController.view)
        viewController.didMoveToParentViewController(self)
        setNeedsStatusBarAppearanceUpdate()
    }
}

public extension Composer where ContainerViewController: ParentViewController {
    public func showComposable(composable: Composable) {
        currentComposables = currentComposables.filter {
            $0.viewController === containerViewController.presentedViewController
        }
        currentComposables.append(composable)
        containerViewController.showViewController(composable.viewController)
    }
}
