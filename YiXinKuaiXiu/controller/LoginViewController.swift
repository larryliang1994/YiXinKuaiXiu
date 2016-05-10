//
//  LoginViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/3.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit
import KYDrawerController

class LoginViewController: UIViewController, UITextFieldDelegate, LoginDelegate {

    @IBOutlet var verifyCodeTextField: UITextField!
    @IBOutlet var telephoneNumTextField: UITextField!
    @IBOutlet var getVerifyCodeButton: UIButton!
    @IBOutlet var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
    }
    
    func initView() {
        getVerifyCodeButton.backgroundColor = UIColor.lightGrayColor()
        getVerifyCodeButton.layer.cornerRadius = 3
        getVerifyCodeButton.enabled = false
        
        loginButton.backgroundColor = UIColor.lightGrayColor()
        loginButton.layer.cornerRadius = 3
        loginButton.enabled = false
        loginButtonEnabled = false
    }
    
    @IBAction func getVerifyCode(sender: UIButton) {
        // 关闭键盘
        telephoneNumTextField.resignFirstResponder()
        
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
        
        self.pleaseWait()
        
        LoginModel(loginDelegate: self).doLogin(telephoneNumTextField.text!, verifyCode: verifyCodeTextField.text!)
    }
    
    func onLoginResult(result: Bool, info: String) {
        self.clearAllNotice()
        if result {
            print("here")
            
            self.noticeSuccess(info, autoClear: true, autoClearTime: 2)
//            if Config.Role == Constants.Role.Customer {
//                performSegueWithIdentifier(Constants.SegueID.CustomerMainSegue, sender: self)
//            } else {
//                performSegueWithIdentifier(Constants.SegueID.HandymanMainSegue, sender: self)
//            }
            
            var initialViewController: UIViewController?
            if Config.Role == Constants.Role.Customer {
                initialViewController = storyboard!.instantiateViewControllerWithIdentifier("CustomerMainVC") as! KYDrawerController
            } else {
                initialViewController = storyboard!.instantiateViewControllerWithIdentifier("HandymanMainVC") as! KYDrawerController
            }
            
            UIView.transitionWithView((UIApplication.sharedApplication().keyWindow)!, duration: 0.5, options: .TransitionCrossDissolve, animations: {
                UIApplication.sharedApplication().keyWindow?.rootViewController = initialViewController
                }, completion: nil)
        
        } else {
            self.noticeError(info, autoClear: true, autoClearTime: 2)
        }
    }
 
    // 控制编辑中的视图样式
    var loginButtonEnabled = false
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if textField == telephoneNumTextField {
            
            if range.location >= 11 {
                return false
            }
            
            let telephoneNum = telephoneNumTextField.text?.characters.count == 10 ?
                telephoneNumTextField.text! + "1" : telephoneNumTextField.text!
            
            if range.location >= 10
                && textField.text?.characters.count == 10
                && UtilBox.isTelephoneNum(telephoneNum){
                
                if !isCounting {
                    getVerifyCodeButton.backgroundColor = Constants.Color.Primary
                    getVerifyCodeButton.enabled = true
                }
                
                if loginButtonEnabled {
                    loginButton.backgroundColor = Constants.Color.Primary
                    loginButton.enabled = true
                }
            } else {
                getVerifyCodeButton.enabled = false
                loginButton.enabled = false
                //loginButtonEnabled = false
                getVerifyCodeButton.backgroundColor = UIColor.lightGrayColor()
                loginButton.backgroundColor = UIColor.lightGrayColor()
            }
        } else if textField == verifyCodeTextField {
            if range.location >= 5 {
                return false
            }
            
            if range.location >= 4 && textField.text?.characters.count == 4 {
                loginButton.enabled = true
                loginButtonEnabled = true
                loginButton.backgroundColor = Constants.Color.Primary
            } else {
                loginButton.enabled = false
                loginButtonEnabled = false
                loginButton.backgroundColor = UIColor.lightGrayColor()
            }
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
