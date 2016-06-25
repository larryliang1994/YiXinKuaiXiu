//
//  GetInitialInfoModel.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/5/4.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import Foundation
import SwiftyJSON

class GetInitialInfoModel: GetInitialInfoProtocol {
    var getInitialInfoDelegate: GetInitialInfoDelegate?
    
    init(getInitialInfoDelegate: GetInitialInfoDelegate?) {
        self.getInitialInfoDelegate = getInitialInfoDelegate
    }
    
    func getMaintenanceType() {
        AlamofireUtil.doRequest(Urls.GetMaintenanceType, parameters: [:]) { (result, response) in
            if result {
                let responseDic = UtilBox.convertStringToDictionary(response)
                
                if responseDic == nil {
                    UtilBox.reportBug(response)
                    self.getInitialInfoDelegate?.onGetMaintenanceTypeResult!(false, info: "获取工种失败")
                    return
                }
                
                let json = JSON(responseDic!)
                
                let ret = json["ret"]
                
                if ret != nil && ret.count != 0 {
                    
                    Config.MTypeNames = []
                    Config.MTypes = []
                    for index in 0 ... ret.count - 1 {
                        let mtypeJson = ret[index]
                        
                        let mtype = MaintenanceType(id: mtypeJson["id"].stringValue, name: mtypeJson["nme"].stringValue)
                        
                        Config.MTypeNames?.append(mtypeJson["nme"].stringValue + "维修")
                        Config.MTypes?.append(mtype)
                    }
                    
                }
                
                self.getInitialInfoDelegate?.onGetMaintenanceTypeResult!(true, info: "")
            } else {
                self.getInitialInfoDelegate?.onGetMaintenanceTypeResult!(false, info: "获取工种失败")
            }
        }
    }
    
    func getFees() {
        AlamofireUtil.doRequest(Urls.GetFeeList, parameters: [:]) { (result, response) in
            if result {
                let responseDic = UtilBox.convertStringToDictionary(response)
                
                if responseDic == nil {
                    UtilBox.reportBug(response)
                    self.getInitialInfoDelegate?.onGetFeeResult!(false, info: "获取默认价格失败")
                    return
                }
                
                let json = JSON(responseDic!)
                
                let ret = json["ret"]
                
                if ret != nil && ret.count != 0 {
                    
                    Config.Fees = []
                    for index in 0 ... ret.count - 1 {
                        Config.Fees.append(ret[index]["nme"].intValue)
                    }
                }
                
                self.getInitialInfoDelegate?.onGetFeeResult!(true, info: "")
            } else {
                self.getInitialInfoDelegate?.onGetFeeResult!(false, info: "获取默认价格失败")
            }
        }
    }
    
    func getMessage() {
        AlamofireUtil.doRequest(Urls.GetMessage, parameters: ["id": Config.Aid!, "tok": Config.VerifyCode!]) { (result, response) in
            if result {
                let responseDic = UtilBox.convertStringToDictionary(response)
                
                if responseDic == nil {
                    UtilBox.reportBug(response)
                    self.getInitialInfoDelegate?.onGetMessageResult!(false, info: "获取默认价格失败")
                    return
                }
                
                let json = JSON(responseDic!)
                
                let ret = json["ret"]
                
                if ret != nil && ret.count != 0 {
                    
                    Config.Messages = []
                    for index in 0 ... ret.count - 1 {
                        let message = Message(id: ret[index]["id"].intValue, title: ret[index]["tit"].stringValue, desc: ret[index]["cmt"].stringValue, date: ret[index]["dte"].stringValue)
                        Config.Messages.append(message)
                    }
                }
                
                self.getInitialInfoDelegate?.onGetMessageResult!(true, info: "")
            } else {
                self.getInitialInfoDelegate?.onGetMessageResult!(false, info: "获取默认价格失败")
            }
        }
    }
    
    func getAds() {
        AlamofireUtil.doRequest(Urls.GetAds, parameters: ["": ""]) { (result, response) in
            if result {
                let responseDic = UtilBox.convertStringToDictionary(response)
                
                if responseDic == nil {
                    UtilBox.reportBug(response)
                    self.getInitialInfoDelegate?.onGetAdsResult!(false, info: "获取广告列表失败")
                    return
                }
                
                let json = JSON(responseDic!)
                
                let ret = json["ret"]
                
                if ret != nil && ret.count != 0 {
                    self.getInitialInfoDelegate?.onGetAdsResult!(true, info: Urls.AdServer + ret[0]["id"].stringValue + ".png")
                } else {
                    self.getInitialInfoDelegate?.onGetAdsResult!(true, info: "")
                }
                
            } else {
                self.getInitialInfoDelegate?.onGetAdsResult!(false, info: "获取广告列表失败")
            }
        }
    }
    
    func getMessageNum() {
        AlamofireUtil.doRequest(Urls.GetMessageNum, parameters: ["id": Config.Aid!, "tok": Config.VerifyCode!]) { (result, response) in
            if result {
                let responseDic = UtilBox.convertStringToDictionary(response)
                
                if responseDic == nil {
                    UtilBox.reportBug(response)
                    self.getInitialInfoDelegate?.onGetMessageNum!(false, info: "获取新消息数目失败")
                    return
                }
                
                let json = JSON(responseDic!)
                
                Config.MessagesNum = json["ret"].intValue
                
                self.getInitialInfoDelegate?.onGetMessageNum!(true, info: "")
            } else {
                self.getInitialInfoDelegate?.onGetMessageNum!(false, info: "获取新消息数目失败")
            }
        }
    }
    
    func getOrderNum() {
        AlamofireUtil.doRequest(Urls.GetOrderNum, parameters: ["id": Config.Aid!, "tok": Config.VerifyCode!, "tpe": Config.Role!]) { (result, response) in
            if result {
                let responseDic = UtilBox.convertStringToDictionary(response)
                
                if responseDic == nil {
                    UtilBox.reportBug(response)
                    self.getInitialInfoDelegate?.onGetOrderNum!(false, info: "获取订单数目失败")
                    return
                }
                let json = JSON(responseDic!)
                
                Config.OrderNum = json["ret"].intValue
                
                self.getInitialInfoDelegate?.onGetOrderNum!(true, info: "")
            } else {
                self.getInitialInfoDelegate?.onGetOrderNum!(false, info: "获取订单数目失败")
            }
        }
    }
    
    func getBlacklist() {
        AlamofireUtil.doRequest(Urls.GetBlacklist, parameters: ["id": Config.Aid!, "tok": Config.VerifyCode!]) { (result, response) in
            if result {
                let responseDic = UtilBox.convertStringToDictionary(response)
                
                if responseDic == nil {
                    UtilBox.reportBug(response)
                    self.getInitialInfoDelegate?.onGetBlacklistResult!(false, info: "获取黑名单失败")
                    return
                }
                let json = JSON(responseDic!)
                
                let ret = json["ret"]
                
                if ret != nil && ret.count != 0 {
                    Config.Blacklist = []
                    for index in 0 ... ret.count - 1 {
                        let blackJson = ret[index]
                        
                        let blackPerson = BlackPerson(
                            name: blackJson["tit"].stringValue,
                            telephone: blackJson["cod"].stringValue,
                            desc: blackJson["cmt"].stringValue,
                            date: blackJson["dte"].stringValue)
                        
                        Config.Blacklist.append(blackPerson)
                    }
                }
                
                self.getInitialInfoDelegate?.onGetBlacklistResult!(true, info: "")
            } else {
                self.getInitialInfoDelegate?.onGetBlacklistResult!(false, info: "获取黑名单失败")
            }
        }
    }
    
    func getCouponList() {
        AlamofireUtil.doRequest(Urls.GetCouponList, parameters: ["id": Config.Aid!, "tok": Config.VerifyCode!]) { (result, response) in
            if result {
                let responseDic = UtilBox.convertStringToDictionary(response)
                
                if responseDic == nil {
                    UtilBox.reportBug(response)
                    self.getInitialInfoDelegate?.onGetCouponListResult!(false, info: "获取抵用券列表失败")
                    return
                }
                let json = JSON(responseDic!)
                
                let ret = json["ret"]
                
                if ret != nil && ret.count != 0 {
                    Config.CouponList = []
                    for index in 0 ... ret.count - 1 {
                        let couponJson = ret[index]
                        
                        let coupon = Coupon(
                            id: couponJson["id"].stringValue,
                            fee: couponJson["num"].intValue,
                            desc: couponJson["cmt"].stringValue,
                            used: couponJson["ste"].intValue == 1,
                            date: couponJson["dte"].stringValue)
                        
                        Config.CouponList.append(coupon)
                    }
                }
                
                self.getInitialInfoDelegate?.onGetCouponListResult!(true, info: "")
            } else {
                self.getInitialInfoDelegate?.onGetCouponListResult!(false, info: "获取抵用券列表失败")
            }
        }
    }
}

@objc protocol GetInitialInfoDelegate {
    optional func onGetMaintenanceTypeResult(result: Bool, info: String)
    optional func onGetFeeResult(result: Bool, info: String)
    optional func onGetMessageResult(result: Bool, info: String)
    optional func onGetAdsResult(result: Bool, info: String)
    optional func onGetMessageNum(result: Bool, info: String)
    optional func onGetOrderNum(result: Bool, info: String)
    optional func onGetBlacklistResult(result: Bool, info: String)
    optional func onGetCouponListResult(result: Bool, info: String)
}