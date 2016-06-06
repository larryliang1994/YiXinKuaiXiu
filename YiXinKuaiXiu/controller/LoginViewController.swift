//
//  LoginViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/3.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit
import KYDrawerController

class LoginViewController: UIViewController, UITextFieldDelegate, LoginDelegate, UserInfoDelegate, GetInitialInfoDelegate {

    @IBOutlet var verifyCodeTextField: UITextField!
    @IBOutlet var telephoneNumTextField: UITextField!
    @IBOutlet var getVerifyCodeButton: UIButton!
    @IBOutlet var loginButton: UIButton!
    
    var alert: OYSimpleAlertController?
    
    let requestNum = 4
    var initRequestNum = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
    }
    
    func initView() {
        getVerifyCodeButton.enabled = false
        getVerifyCodeButton.backgroundColor = UIColor.lightGrayColor()
        
        loginButton.backgroundColor = UIColor.lightGrayColor()
        loginButton.enabled = false
        loginButtonEnabled = false
    }
    
    @IBAction func getVerifyCode(sender: UIButton) {
        // 关闭键盘
        telephoneNumTextField.resignFirstResponder()
        
        if !UtilBox.isTelephoneNum(telephoneNumTextField.text!) {
            UtilBox.alert(self, message: "请输入11位手机号")
            return
        }
        
        self.pleaseWait()
        
        LoginModel(loginDelegate: self).doGetVerifyCode(Config.Role!, telephoneNum: telephoneNumTextField.text!)
        
        let timer = NSTimer.scheduledTimerWithTimeInterval(
            1.0, target: self, selector: #selector(LoginViewController.counting(_:)),
            userInfo: nil, repeats: true)
        time = 60
        
        timer.tolerance = 0.1
        timer.fire()
    }
    
    func onGetVerifyCodeResult(result: Bool, info: String) {
        self.clearAllNotice()
        
        if result {
            self.noticeSuccess(info, autoClear: true, autoClearTime: 2)
        } else {
            self.noticeError(info, autoClear: true, autoClearTime: 2)
        }
    }

    @IBAction func login(sender: UIButton) {
        verifyCodeTextField.resignFirstResponder()
        
        if !UtilBox.isTelephoneNum(telephoneNumTextField.text!) {
            UtilBox.alert(self, message: "请输入11位手机号")
            return
        } else if verifyCodeTextField.text?.characters.count != 5 {
            UtilBox.alert(self, message: "请输入5位验证码")
            return
        }
        
        self.pleaseWait()
        
        LoginModel(loginDelegate: self).doLogin(telephoneNumTextField.text!, verifyCode: verifyCodeTextField.text!)
    }
    
    func onLoginResult(result: Bool, info: String) {
        if result {
            UserInfoModel(userInfoDelegate: self).doGetUserInfo()
            
            let getInitialInfoModel = GetInitialInfoModel(getInitialInfoDelegate: self)
            getInitialInfoModel.getMaintenanceType()
            getInitialInfoModel.getMessageNum()
            getInitialInfoModel.getOrderNum()
        } else {
            self.clearAllNotice()
            self.noticeError(info, autoClear: true, autoClearTime: 2)
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
    
    func onGetUserInfoResult(result: Bool, info: String) {
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
    
    func onGetMaintenanceTypeResult(result: Bool, info: String) {
        if result {
            initRequestNum += 1
            
            if initRequestNum == requestNum {
                self.clearAllNotice()
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
    
    func showMainScreen() {
        var initialViewController: UIViewController?
        if Config.Role == Constants.Role.Customer {
            initialViewController = storyboard!.instantiateViewControllerWithIdentifier("CustomerMainVC") as! KYDrawerController
        } else {
            initialViewController = storyboard!.instantiateViewControllerWithIdentifier("HandymanMainVC") as! KYDrawerController
        }
        
        self.clearAllNotice()
        
        UIView.transitionWithView((UIApplication.sharedApplication().keyWindow)!, duration: 0.5, options: .TransitionCrossDissolve, animations: {
            UIApplication.sharedApplication().keyWindow?.rootViewController = initialViewController
            }, completion: nil)
    }
 
    // 控制编辑中的视图样式
    var loginButtonEnabled = false
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if !UtilBox.isNum(string, digital: false) {
            return false
        }
        
        if textField == telephoneNumTextField {
            
            if range.location >= 11 {
                return false
            }
            
            if textField.text?.characters.count == 0 && range.location == 0 {
                if !isCounting {
                    getVerifyCodeButton.backgroundColor = Constants.Color.Primary
                    getVerifyCodeButton.enabled = true
                }
            } else if textField.text?.characters.count == 1 && range.location == 0 {
                getVerifyCodeButton.enabled = false
                loginButton.enabled = false
                getVerifyCodeButton.backgroundColor = UIColor.lightGrayColor()
                loginButton.backgroundColor = UIColor.lightGrayColor()
            }
            

//            
//            let telephoneNum = telephoneNumTextField.text?.characters.count == 10 ?
//                telephoneNumTextField.text! + "1" : telephoneNumTextField.text!
//            
//            if range.location >= 10
//                && textField.text?.characters.count == 10
//                && UtilBox.isTelephoneNum(telephoneNum){
//                
//                if !isCounting {
//                    getVerifyCodeButton.backgroundColor = Constants.Color.Primary
//                    getVerifyCodeButton.enabled = true
//                }
//                
//                if loginButtonEnabled {
//                    loginButton.backgroundColor = Constants.Color.Primary
//                    loginButton.enabled = true
//                }
//            } else {
//                getVerifyCodeButton.enabled = false
//                loginButton.enabled = false
//                //loginButtonEnabled = false
//                getVerifyCodeButton.backgroundColor = UIColor.lightGrayColor()
//                loginButton.backgroundColor = UIColor.lightGrayColor()
//            }
        } else if textField == verifyCodeTextField {
            if range.location >= 5 {
                return false
            }
            
            if textField.text?.characters.count == 0 && range.location == 0 {
                loginButton.enabled = true
                loginButtonEnabled = true
                loginButton.backgroundColor = Constants.Color.Primary
            } else if textField.text?.characters.count == 1 && range.location == 0 {
                loginButton.enabled = false
                loginButtonEnabled = false
                loginButton.backgroundColor = UIColor.lightGrayColor()
            }
            
//            if range.location >= 4 && textField.text?.characters.count == 4 {
//                loginButton.enabled = true
//                loginButtonEnabled = true
//                loginButton.backgroundColor = Constants.Color.Primary
//            } else {
//                loginButton.enabled = false
//                loginButtonEnabled = false
//                loginButton.backgroundColor = UIColor.lightGrayColor()
//            }
        }
        
        return true
    }
    
    // 倒计时
    var time = 60
    var isCounting = false
    func counting(timer: NSTimer) {
        _ = timer.userInfo
        
        if time != 0 {
            isCounting = true
            getVerifyCodeButton.backgroundColor = UIColor.lightGrayColor()
            getVerifyCodeButton.enabled = false
            getVerifyCodeButton.setTitle("\(time)秒", forState: .Normal)
            time -= 1
        } else {
            isCounting = false
            getVerifyCodeButton.setTitle("验证", forState: .Normal)
            timer.invalidate()
            
            if telephoneNumTextField.text?.characters.count >= 11 {
                getVerifyCodeButton.backgroundColor = Constants.Color.Primary
                getVerifyCodeButton.enabled = true
            } else {
                getVerifyCodeButton.backgroundColor = UIColor.lightGrayColor()
                getVerifyCodeButton.enabled = false
            }
        }
    }
}
