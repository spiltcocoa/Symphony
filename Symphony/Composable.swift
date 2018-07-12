//
//  Composable.swift
//  Symphony
//
//  Created by Zak Remer on 10/13/16.
//  Copyright © 2016 Spilt Cocoa. All rights reserved.
//

import UIKit

/// a type that can be presented by a Composer.
public protocol Composable: class {
    var viewController: UIViewController { get }
}

public extension Composable where Self: Composer {
    var viewController: UIViewController { return containerViewController }
}
