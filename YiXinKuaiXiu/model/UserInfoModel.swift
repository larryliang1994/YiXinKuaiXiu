//
//  UserInfoModel.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/26.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import Foundation
import SwiftyJSON

class UserInfoModel: UserInfoProtocol {
    var userInfoDelegate : UserInfoDelegate
    
    init(userInfoDelegate : UserInfoDelegate) {
        self.userInfoDelegate = userInfoDelegate
    }
    
    func doGetUserInfo() {
        AlamofireUtil.doRequest(Urls.GetUserInfo, parameters: ["id": Config.Aid!, "tok": Config.VerifyCode!]) { (result, response) in
            if result {
                print(response)
                let json = JSON(UtilBox.convertStringToDictionary(response)!)
                
                let ret = json["ret"].intValue
                
                if ret == 0 {
                    self.handleUserInfo(json)
                    self.userInfoDelegate.onGetUserInfoResult!(true, info: "")
                } else if ret == 1 {
                    self.userInfoDelegate.onGetUserInfoResult!(false, info: "获取用户信息失败")
                } else {
                    self.userInfoDelegate.onGetUserInfoResult!(false, info: "用户被锁定")
                }
                
            } else {
                self.userInfoDelegate.onGetUserInfoResult!(false, info: "获取用户信息失败")
            }
        }
    }
    
    func doModifyUserInfo(parameters: [String : String]) {
        AlamofireUtil.doRequest(Urls.ModifyUserInfo, parameters: ["id": Config.Aid!, "tok": Config.VerifyCode!, "fld": parameters["key"]!, "val": parameters["value"]!]) { (result, response) in
            if result {
                let json = JSON(UtilBox.convertStringToDictionary(response)!)
                
                let ret = json["ret"].intValue
                
                if ret == 0 {
                    self.userInfoDelegate.onModifyUserInfoResult!(true, info: "")
                } else if ret == 1 {
                    self.userInfoDelegate.onModifyUserInfoResult!(false, info: "认证失败")
                } else if ret == 2 {
                    self.userInfoDelegate.onModifyUserInfoResult!(false, info: "字段错误")
                } else if ret == 3 {
                    self.userInfoDelegate.onModifyUserInfoResult!(false, info: "失败")
                }
            } else {
                self.userInfoDelegate.onModifyUserInfoResult!(false, info: "设置失败")
            }
        }
    }
    
    func doUpdateLocationInfo(parameters: [String]) {
        let paramters = ["id": Config.Aid!, "tok": Config.VerifyCode!, "lot": parameters[0], "lat": parameters[1]]
        
        AlamofireUtil.doRequest(Urls.UpdateLocationInfo, parameters: paramters) { (result, response) in
            if result {
                let json = JSON(UtilBox.convertStringToDictionary(response)!)
                
                let ret = json["ret"].intValue
                
                if ret == 0 {
                    self.userInfoDelegate.onUpdateLocationInfoResult!(true, info: "")
                } else if ret == 1 {
                    self.userInfoDelegate.onUpdateLocationInfoResult!(false, info: "认证失败")
                } else if ret == 2 {
                    self.userInfoDelegate.onUpdateLocationInfoResult!(false, info: "失败")
                }
            } else {
                self.userInfoDelegate.onUpdateLocationInfoResult!(false, info: "设置失败")
            }
        }
    }
    
    func doGetHandymanInfo(id: String) {
        AlamofireUtil.doRequest(Urls.GetHandymanInfo, parameters: ["bid": id]) { (result, response) in
            if result {
                
                print(response)
                let json = JSON(UtilBox.convertStringToDictionary(response)!)
                
                let ret = json["ret"].intValue
                
                if ret == 0 {
                    self.userInfoDelegate
                        .onGetHandymanInfoResult!(true, info: "",
                                                  name: json["nme"].stringValue,
                                                  telephoneNum: json["cod"].stringValue,
                                                  sex: json["sex"].intValue,
                                                  age: json["age"].intValue,
                                                  star: json["fen"].intValue,
                                                  mNum: json["cnt"].intValue)
                } else if ret == 1 {
                    self.userInfoDelegate.onGetHandymanInfoResult!(false, info: "获取师傅信息失败", name: "", telephoneNum: "", sex: 0, age: 0, star: 0, mNum: 0)
                }
            } else {
                self.userInfoDelegate.onGetHandymanInfoResult!(false, info: "获取师傅信息失败", name: "", telephoneNum: "", sex: 0, age: 0, star: 0, mNum: 0)
            }
        }
    }
    
    func doChangePassword(old: String, new: String) {
        let paramters = ["id": Config.Aid!, "tok": Config.VerifyCode!, "old": old, "new": new]
        
        AlamofireUtil.doRequest(Urls.ChangePassword, parameters: paramters) { (result, response) in
            if result {
                let json = JSON(UtilBox.convertStringToDictionary(response)!)
                
                let ret = json["ret"].intValue
                
                if ret == 0 {
                    self.userInfoDelegate.onChangePassword!(true, info: "")
                } else if ret == 1 {
                    self.userInfoDelegate.onChangePassword!(false, info: "认证失败")
                } else if ret == 2 {
                    self.userInfoDelegate.onChangePassword!(false, info: "原密码错误")
                } else if ret == 3 {
                    self.userInfoDelegate.onChangePassword!(false, info: "失败")
                }
            } else {
                self.userInfoDelegate.onChangePassword!(false, info: "修改失败")
            }
        }
    }
    
    func handleUserInfo(json: JSON) {
        Config.Name = json["nme"].stringValue == "" ? nil : json["nme"].stringValue
        Config.Location = json["adr"].stringValue == "" ? nil : json["adr"].stringValue
        Config.Company = json["qym"].stringValue == "" ? nil : json["qym"].stringValue
        Config.Age = json["age"].stringValue == "" ? nil : json["age"].stringValue
        Config.Money = json["mxj"].stringValue == "" ? nil : json["mxj"].stringValue
        Config.Sex = json["sex"].stringValue == "" ? nil : json["sex"].stringValue
        Config.IDNum = json["sfz"].stringValue == "" ? nil : json["sfz"].stringValue
        Config.MType = json["lxs"].stringValue == "" ? nil : json["lxs"].stringValue
        Config.Password = json["pwd"].stringValue == "" ? nil : json["pwd"].stringValue
        Config.BankName = json["yhm"].stringValue == "" ? nil : json["yhm"].stringValue
        Config.BankNum = json["yhh"].stringValue == "" ? nil : json["yhh"].stringValue
        Config.TotalStar = json["fen"].stringValue == "" ? nil : json["fen"].stringValue
        Config.MaintenanceNum = json["cnt"].stringValue == "" ? nil : json["cnt"].stringValue
        Config.Audited = json["lck"].intValue
        Config.MTypeIDString = json["lxs"].stringValue
        Config.ContactTelephone = json["phe"].stringValue
        
        if !(Config.Money?.containsString("."))! {
            Config.Money?.appendContentsOf(".00")
        }
    }
}

@objc protocol UserInfoDelegate {
    optional func onGetUserInfoResult(result: Bool, info: String)
    optional func onModifyUserInfoResult(result: Bool, info: String)
    optional func onUpdateLocationInfoResult(result: Bool, info: String)
    optional func onGetHandymanInfoResult(result: Bool, info: String, name: String, telephoneNum: String, sex: Int, age: Int, star: Int, mNum: Int)
    optional func onChangePassword(result: Bool, info: String)
}