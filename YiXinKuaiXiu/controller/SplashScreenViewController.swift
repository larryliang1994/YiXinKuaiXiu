//
//  SplashScreenViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/26.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit
import KYDrawerController

class SplashScreenViewController: UIViewController, UserInfoDelegate, GetInitialInfoDelegate {

    var window: UIWindow?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getStarted()
        
        if Config.Aid != "" && Config.VerifyCode != "" {
            UserInfoModel(userInfoDelegate: self).doGetUserInfo()
        } else {
            showMainScreen()
        }
    }
    
    func showMainScreen() {
        let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
        dispatch_async(dispatch_get_global_queue(qos, 0)) { () -> Void in
            sleep(1)
            dispatch_async(dispatch_get_main_queue(), {
                UIView.transitionWithView((UIApplication.sharedApplication().keyWindow)!, duration: 0.5, options: .TransitionCrossDissolve, animations: {
                    self.window?.makeKeyAndVisible()
                    }, completion: nil)
            })
        }
    }
    
    func onGetUserInfoResult(result: Bool, info: String) {
        if result {
            GetInitialInfoModel(getInitialInfoDelegate: self).getMaintenanceType()
        } else {
            UtilBox.alert(self, message: info)
        }
    }
    
    func onGetMaintenanceTypeResult(result: Bool, info: String) {
        if result {
            showMainScreen()
        } else {
            UtilBox.alert(self, message: info)
        }
    }
    
    func onModifyUserInfoResult(result: Bool, info: String) {}
    
    func getStarted() {
        // 初始化百度地图
        initBMK()
        
        // 初始化Bugly
        Bugly.startWithAppId(Constants.Key.BuglyAppID)
        
        // 初始化数据统计服务
        MobClick.startWithAppkey(Constants.Key.UMAppKey, reportPolicy: BATCH,
                                 channelId: "developer")
        
        setInitialViewController()
    }

    func setInitialViewController() {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let userDefault = NSUserDefaults.standardUserDefaults()
        Config.Role = userDefault.stringForKey(Constants.UserDefaultKey.Role)!
        Config.TelephoneNum = userDefault.stringForKey(Constants.UserDefaultKey.TelephoneNum)!
        Config.VerifyCode = userDefault.stringForKey(Constants.UserDefaultKey.VerifyCode)!
        Config.Aid = userDefault.stringForKey(Constants.UserDefaultKey.Aid)!
        
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
    }
    
    func initBMK(){
        let mapManager = BMKMapManager()
        
        let ret = mapManager.start(Constants.Key.BaiDuMapAK, generalDelegate: nil)
        if ret == false {
            NSLog("manager start failed!")
        }
    }
}

extension Int
{
    func toString() -> String
    {
        let myString = String(self)
        return myString
    }
}
