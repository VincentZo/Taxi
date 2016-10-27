//
//  AppDelegate.swift
//  Taxi
//
//  Created by Vincent on 16/10/13.
//  Copyright © 2016年 com.vincent.study. All rights reserved.
//

import UIKit
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,BMKGeneralDelegate {

    var window: UIWindow?
    var mapManager : BMKMapManager?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.showHomePage()
        self.mapManager = BMKMapManager()
        let ret = self.mapManager!.start("Ze0Nq7HAG4PdN9kOhXlQb578CDUcPR70", generalDelegate: self)
        if !ret{
            Log(messageType: "Error",message: "百度地图开启出错...")
        }

        return true

    }
    
    func showHomePage(){
        let storyBoard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let homePage = storyBoard.instantiateViewController(withIdentifier: HomePageIndentifier) as! HomePage
        let navController = UINavigationController.init(rootViewController: homePage)
        self.window?.rootViewController = navController
        self.window?.makeKeyAndVisible()
    }
 
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

