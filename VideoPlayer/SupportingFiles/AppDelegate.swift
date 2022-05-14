//
//  AppDelegate.swift
//  Video Player
//
//  Created by Shreeji on 21/10/21.
//  Copyright © 2021 Shreeji. All rights reserved.
//

import UIKit
import MediaPlayer
import MobileCoreServices

var myWindow: UIWindow?

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var orientationLock = UIInterfaceOrientationMask.all
    var sendbox_videoUrl:URL?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
                       

        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeTabbarController")
        let navigationController = viewController.makeNavigation()
        myWindow = UIWindow(frame: UIScreen.main.bounds)
        myWindow?.rootViewController = navigationController
        myWindow?.makeKeyAndVisible()
        URLManager.videoThumbURL().createFolder()

        
        return true
    }

    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
   
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        NotificationCenter.default.post(name: .refreshLocalScreen, object: nil)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
         return self.orientationLock
     }

}


