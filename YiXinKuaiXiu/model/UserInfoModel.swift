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
                    self.userInfoDelegate.onGetUserInfoResult(true, info: "")
                } else if ret == 1 {
                    self.userInfoDelegate.onGetUserInfoResult(false, info: "获取用户信息失败")
                } else {
                    self.userInfoDelegate.onGetUserInfoResult(false, info: "用户被锁定")
                }
                
            } else {
                self.userInfoDelegate.onGetUserInfoResult(false, info: "获取用户信息失败")
            }
        }
    }
    
    func doModifyUserInfo(parameters: [String : String]) {
        AlamofireUtil.doRequest(Urls.ModifyUserInfo, parameters: ["id": Config.Aid!, "tok": Config.VerifyCode!, "fld": parameters["key"]!, "val": parameters["value"]!]) { (result, response) in
            if result {
                let json = JSON(UtilBox.convertStringToDictionary(response)!)
                
                let ret = json["ret"].intValue
                
                if ret == 0 {
                    self.userInfoDelegate.onModifyUserInfoResult(true, info: "")
                } else if ret == 1 {
                    self.userInfoDelegate.onModifyUserInfoResult(false, info: "认证失败")
                } else if ret == 2 {
                    self.userInfoDelegate.onModifyUserInfoResult(false, info: "字段错误")
                } else if ret == 3 {
                    self.userInfoDelegate.onModifyUserInfoResult(false, info: "失败")
                }
            } else {
                self.userInfoDelegate.onModifyUserInfoResult(false, info: "设置失败")
            }
        }
    }
    
    func doUpdateLocationInfo(parameters: [String]) {
        let paramters = ["id": Config.Aid!, "tok": Config.VerifyCode!, "lot": parameters[0], "lat": parameters[1]]
        
        print(paramters)
        
        AlamofireUtil.doRequest(Urls.UpdateLocationInfo, parameters: paramters) { (result, response) in
            if result {
                print(response)
                
                let json = JSON(UtilBox.convertStringToDictionary(response)!)
                
                let ret = json["ret"].intValue
                
                if ret == 0 {
                    self.userInfoDelegate.onUpdateLocationInfoResult(true, info: "")
                } else if ret == 1 {
                    self.userInfoDelegate.onUpdateLocationInfoResult(false, info: "认证失败")
                } else if ret == 2 {
                    self.userInfoDelegate.onUpdateLocationInfoResult(false, info: "失败")
                }
            } else {
                self.userInfoDelegate.onUpdateLocationInfoResult(false, info: "设置失败")
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
        
        if !(Config.Money?.containsString("."))! {
            Config.Money?.appendContentsOf(".00")
        }
    }
}

protocol UserInfoDelegate {
    func onGetUserInfoResult(result: Bool, info: String)
    func onModifyUserInfoResult(result: Bool, info: String)
    func onUpdateLocationInfoResult(result: Bool, info: String)
}