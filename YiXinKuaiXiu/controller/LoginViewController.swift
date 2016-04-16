//
//  LoginViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/3.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var verifyCodeTextField: UITextField!
    @IBOutlet var telephoneNumTextField: UITextField!
    @IBOutlet var getVerifyCodeButton: UIButton!
    @IBOutlet var loginButton: UIButton!
    
    var role: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getVerifyCodeButton.backgroundColor = UIColor.lightGrayColor()
        getVerifyCodeButton.layer.cornerRadius = 3
        
        loginButton.backgroundColor = UIColor.lightGrayColor()
        loginButton.layer.cornerRadius = 3
    }
    
    @IBAction func getVerifyCode(sender: UIButton) {
        //self.pleaseWait()
        
        // 关闭键盘
        telephoneNumTextField.resignFirstResponder()
        
        //GetVerifyCodeModel(getVerifyCodeDelegate: self).doGetVerifyCode(telephoneNumTextField.text!)
        
        let timer = NSTimer.scheduledTimerWithTimeInterval(
            1.0, target: self, selector: #selector(LoginViewController.counting(_:)),
            userInfo: nil, repeats: true)
        time = 60
        
        timer.tolerance = 0.1
        timer.fire()
    }

    @IBAction func login(sender: UIButton) {
        if Config.Role == "customer" {
            performSegueWithIdentifier(Constants.SegueID.CustomerMainSegue, sender: self)
        } else {
            performSegueWithIdentifier(Constants.SegueID.HandymanMainSegue, sender: self)
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
            if range.location >= 6 {
                return false
            }
            
            if range.location >= 5 && textField.text?.characters.count == 5 {
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
            getVerifyCodeButton.backgroundColor = Constants.Color.Primary
            getVerifyCodeButton.enabled = true
            getVerifyCodeButton.setTitle("验证", forState: .Normal)
            timer.invalidate()
            
            textField(telephoneNumTextField, shouldChangeCharactersInRange: NSRange(location: 10, length: 1), replacementString: telephoneNumTextField.text!)
        }
    }
}
