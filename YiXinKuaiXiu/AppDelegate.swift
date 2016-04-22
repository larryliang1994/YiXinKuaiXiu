//
//  AppDelegate.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/3.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit
import KYDrawerController

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        setInitialViewController()
        
        // 初始化百度地图
        initBMK()
        
        // 初始化Bugly
        Bugly.startWithAppId(Constants.Key.BuglyAppID)
        
        // 初始化数据统计服务
        MobClick.startWithAppkey(Constants.Key.UMAppKey, reportPolicy: BATCH,
                                 channelId: "developer")
        
        return true
    }
    
    func setInitialViewController() {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let userDefault = NSUserDefaults.standardUserDefaults()
        Config.Role = userDefault.stringForKey(Constants.UserDefaultKey.Role)
        Config.TelephoneNum = userDefault.stringForKey(Constants.UserDefaultKey.TelephoneNum)
        Config.VerifyCode = userDefault.stringForKey(Constants.UserDefaultKey.VerifyCode)
        Config.Aid = userDefault.stringForKey(Constants.UserDefaultKey.Aid)
        
        var initialViewController: UIViewController?
        if Config.Role != nil && Config.TelephoneNum != nil && Config.VerifyCode != nil && Config.Aid != nil {
            if Config.Role == Constants.Role.Customer {
                initialViewController = storyboard.instantiateViewControllerWithIdentifier("CustomerMainVC") as! KYDrawerController
            } else {
                
                initialViewController = storyboard.instantiateViewControllerWithIdentifier("HandymanMainVC") as! KYDrawerController
            }
        } else {
            initialViewController = storyboard.instantiateViewControllerWithIdentifier("WelcomeVCNavigation") as! UINavigationController
        }
    
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
    }
    
    func initBMK(){
        let mapManager = BMKMapManager()
        
        let ret = mapManager.start(Constants.Key.BaiDuMapAK, generalDelegate: nil)
        if ret == false {
            NSLog("manager start failed!")
        }
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

