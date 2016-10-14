//
//  AppDelegate.swift
//  SymphonyTestsHost
//
//  Created by Zak Remer on 10/14/16.
//  Copyright © 2016 Spilt Cocoa. All rights reserved.
//

import UIKit
import Symphony

@UIApplicationMain
class AppDelegate: UIViewController, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        window?.rootViewController = self
        window?.makeKeyAndVisible()
        return true
    }
}

