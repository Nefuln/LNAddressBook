//
//  AppDelegate.swift
//  LNAddressBook
//
//  Created by 浪漫满屋 on 2017/7/29.
//  Copyright © 2017年 com.man.www. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: LNAddressBookVC())
        window?.makeKeyAndVisible()
        
        return true
    }


}

