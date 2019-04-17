//
//  AppDelegate.swift
//  GiTiny
//
//  Created by DongHeeKang on 24/12/2018.
//  Copyright © 2018 k-lpmg. All rights reserved.
//

import UIKit

import AwaitToast
import Crashlytics
import Fabric
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        
        AppNavigator.shared.start(in: window)
        AppAppearance.shared.start()
        toastConfig()
        
        #if DEBUG
            Fabric.with([Crashlytics.self])
        #endif
        return true
    }
    
    // MARK: - Private methods
    
    private func toastConfig() {
        ToastBehaviorManager.default.duration = 5.0
        ToastAppearanceManager.default.height = AutomaticDimension
    }

}
