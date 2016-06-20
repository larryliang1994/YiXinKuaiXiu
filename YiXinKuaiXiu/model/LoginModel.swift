//
//  loginModel.swift
//  TaskMoment
//
//  Created by 梁浩 on 15/12/14.
//  Copyright © 2015年 LeungHowell. All rights reserved.
//

import Foundation
import SwiftyJSON

class LoginModel : LoginProtocol{
    var loginDelegate : LoginDelegate
    
    init(loginDelegate : LoginDelegate) {
        self.loginDelegate = loginDelegate
    }
    
    func doGetVerifyCode(type: String, telephoneNum: String, refereeTelephone: String?) {
        let parameters = refereeTelephone == nil ?
            ["tpe": type, "cod": telephoneNum] : ["tpe": type, "cod": telephoneNum, "tjr": refereeTelephone!]
        
        AlamofireUtil.doRequest(Urls.GetVerifyCode, parameters: parameters) { (result, response) in
            if result {
                let responseDic = UtilBox.convertStringToDictionary(response)
                
                if responseDic == nil {
                    UtilBox.reportBug(response)
                    self.loginDelegate.onGetVerifyCodeResult(false, info: "短信发送失败")
                    return
                }
                
                let json = JSON(responseDic!)
                
                let ret = json["ret"].intValue
                
                if ret == Constants.Success {
                    //print(json["tok"].intValue)
                    
                    self.loginDelegate.onGetVerifyCodeResult(true, info: "短信已发送")
                    //self.loginDelegate.onGetVerifyCodeResult(true, info: json["tok"].intValue.toString())
                } else {
                    var info = ""
                    if ret == 1 {
                        info = "手机号码错误"
                    } else if ret == 2 {
                        info = "会员类型错误"
                    } else if ret == 3 {
                        info = "短信发送失败"
                    } else if ret == 4 {
                        info = "不存在该推荐人"
                    }
                    
                    self.loginDelegate.onGetVerifyCodeResult(false, info: info)
                }
                
            } else {
                self.loginDelegate.onGetVerifyCodeResult(false, info: "短信发送失败")
            }
        }
    }
    
    func doLogin(telephoneNum: String, verifyCode: String) {
        AlamofireUtil.doRequest(Urls.Login, parameters: ["cod": telephoneNum, "tok": verifyCode]) { (result, response) in
            if result {
                let responseDic = UtilBox.convertStringToDictionary(response)
                
                if responseDic == nil {
                    UtilBox.reportBug(response)
                    self.loginDelegate.onLoginResult(false, info: "登录失败")
                    return
                }
                
                let json = JSON(responseDic!)
                
                let ret = json["ret"].intValue
                
                if ret == Constants.Success {
                    Config.Aid = json["aid"].stringValue
                    Config.TelephoneNum = telephoneNum
                    Config.VerifyCode = verifyCode
                    
                    self.handleUserDefault()
                    
                    self.loginDelegate.onLoginResult(true, info: "登录成功")
                } else {
                    var info = ""
                    if ret == 1 {
                        info = "验证码错误"
                    } else if ret == 2 {
                        info = "用户被锁定"
                    }
                    
                    self.loginDelegate.onLoginResult(false, info: info)
                }
                
            } else {
                self.loginDelegate.onLoginResult(false, info: "登录失败")
            }
        }
    }
    
    func handleUserDefault() {
        let userDefault = NSUserDefaults.standardUserDefaults()
        
        userDefault.setValue(Config.TelephoneNum, forKey: Constants.UserDefaultKey.TelephoneNum)
        userDefault.setValue(Config.VerifyCode, forKey: Constants.UserDefaultKey.VerifyCode)
        userDefault.setValue(Config.Aid, forKey: Constants.UserDefaultKey.Aid)
        userDefault.setValue(Config.Role, forKey: Constants.UserDefaultKey.Role)
    }
}

protocol LoginDelegate {
    func onGetVerifyCodeResult(result: Bool, info: String)
    func onLoginResult(result: Bool, info: String)
}