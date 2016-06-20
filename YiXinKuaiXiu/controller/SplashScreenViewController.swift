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
    
    @IBOutlet var imageView: UIImageView!

    var window: UIWindow?
    
    var alert: OYSimpleAlertController?
    
    let requestNum = 5
    var initRequestNum = 0
    
    var sleepTime: UInt32 = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = UIImage(named: "defaultAd")
        
        getStarted()
        
        getInitialInfo()
    }
    
    func getStarted() {
        // 初始化百度地图
        initBMK()
        
        // 初始化BeeCloud
        initBeeCloud()
        
        // 初始化Bugly
        Bugly.startWithAppId(Constants.Key.BuglyAppID)
        
        // 初始化数据统计服务
        initUMAnalytics()
        
        // 设置起始页面
        setInitialViewController()
    }
    
    func getInitialInfo() {
        if alert != nil {
            alert?.dismissViewControllerAnimated(true, completion: nil)
            alert = nil
            self.pleaseWait()
        }
        
        if Config.Aid != nil && Config.Aid != "" && Config.VerifyCode != nil && Config.VerifyCode != "" {
            sleepTime = 0
            
            UserInfoModel(userInfoDelegate: self).doGetUserInfo()
            
            let getInitialInfoModel = GetInitialInfoModel(getInitialInfoDelegate: self)
            getInitialInfoModel.getMaintenanceType()
            getInitialInfoModel.getAds()
            getInitialInfoModel.getMessageNum()
            getInitialInfoModel.getOrderNum()
        } else {
            sleepTime = 0
            
            let getInitialInfoModel = GetInitialInfoModel(getInitialInfoDelegate: self)
            getInitialInfoModel.getAds()
            showMainScreen()
        }
    }
    
    func showMainScreen() {
        let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
        dispatch_async(dispatch_get_global_queue(qos, 0)) { () -> Void in
            sleep(self.sleepTime)
            dispatch_async(dispatch_get_main_queue(), {
                self.clearAllNotice()
                UIView.transitionWithView((UIApplication.sharedApplication().keyWindow)!, duration: 0.5, options: .TransitionCrossDissolve, animations: {
                    self.window?.makeKeyAndVisible()
                    }, completion: { (Bool) in
                    self.imageView.image = nil
                    self.imageView.backgroundColor = UIColor.whiteColor()
                })
            })
        }
    }
    
    func onGetUserInfoResult(result: Bool, info: String) {
        if result {
            initRequestNum += 1
            
            if initRequestNum == requestNum {
                showMainScreen()
            }
            
        } else {
            // 强制要求登录
            if info == "1" {
                alert?.dismissViewControllerAnimated(true, completion: nil)
                let alertController = UIAlertController(title: nil, message: "登录信息已过期，请重新登录", preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "好的", style: .Default, handler: { (UIAlertAction) in
                    UtilBox.clearUserDefaults()
                    
                    self.window?.rootViewController = self.storyboard!.instantiateViewControllerWithIdentifier("WelcomeVCNavigation")
                    UIView.transitionWithView((UIApplication.sharedApplication().keyWindow)!, duration: 0.5, options: .TransitionCrossDissolve, animations: {
                        self.window?.makeKeyAndVisible()
                        }, completion: { (Bool) in
                            self.imageView.image = nil
                            self.imageView.backgroundColor = UIColor.whiteColor()
                    })
                })
                alertController.addAction(okAction)
                
                presentViewController(alertController, animated: true, completion: nil)
            } else if alert == nil {
                alert(info)
            }
        }
    }
    
    func onGetMaintenanceTypeResult(result: Bool, info: String) {
        if result {
            initRequestNum += 1
            
            if initRequestNum == requestNum {
                showMainScreen()
            }
        } else {
            if alert == nil {
                alert(info)
            }
        }
    }
    
    func onGetOrderNum(result: Bool, info: String) {
        if result {
            initRequestNum += 1
            
            if initRequestNum == requestNum {
                showMainScreen()
            }
        } else {
            if alert == nil {
                alert(info)
            }
        }
    }
    
    func onGetMessageNum(result: Bool, info: String) {
        if result {
            initRequestNum += 1
            
            if initRequestNum == requestNum {
                showMainScreen()
            }
        } else {
            if alert == nil {
                alert(info)
            }
        }
    }
    
    func onGetAdsResult(result: Bool, info: String) {
        if result {
            initRequestNum += 1
            
            imageView.hnk_setImageFromURL(NSURL(string: info)!)
            
            if initRequestNum == requestNum {
                showMainScreen()
            }
        } else {
            if alert == nil {
                alert(info)
            }
        }
    }
    
    func alert(info: String) {
        self.clearAllNotice()
        initRequestNum = 0
        
        alert = OYSimpleAlertController()
        UtilBox.showAlertView(self, alertViewController: alert!, message: info, cancelButtonTitle: "退出", cancelButtonAction: #selector(SplashScreenViewController.close), confirmButtonTitle: "重试", confirmButtonAction: #selector(SplashScreenViewController.getInitialInfo))
    }
    
    func close() {
        alert?.dismissViewControllerAnimated(true, completion: nil)
        alert = nil
        exit(0)
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
    }
    
    func initUMAnalytics() {
        MobClick.setLogEnabled(true)
        let config = UMAnalyticsConfig.init()
        config.appKey=Constants.Key.UMAppKey
        config.bCrashReportEnabled = true
        config.ePolicy = BATCH
        config.channelId = "developer"
        MobClick.startWithConfigure(config)
    }
    
    func initBMK(){
        let mapManager = BMKMapManager()
        
        let ret = mapManager.start(Constants.Key.BaiDuMapAK, generalDelegate: nil)
        if ret == false {
            NSLog("manager start failed!")
        }
        
    }
    
    func initBeeCloud() {
        BeeCloud.initWithAppID(Constants.Key.BeeCloudAppID, andAppSecret: Constants.Key.BeeCloudAppSecret)
        BeeCloud.initWeChatPay(Constants.Key.WechatAppID)
    }
}
