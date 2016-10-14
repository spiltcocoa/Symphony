//
//  Composable.swift
//  Symphony
//
//  Created by Zak Remer on 10/13/16.
//  Copyright © 2016 Spilt Cocoa. All rights reserved.
//

import UIKit

public protocol Composable: class {
    var viewController: UIViewController { get }
}
