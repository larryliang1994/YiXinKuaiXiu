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
        AlamofireUtil.doRequest(Urls.GetAds, parameters: ["id": Config.Aid!, "tok": Config.VerifyCode!]) { (result, response) in
            if result {
                print(response)
                let responseDic = UtilBox.convertStringToDictionary(response)
                
                if responseDic == nil {
                    self.getInitialInfoDelegate?.onGetFeeResult!(false, info: "获取默认价格失败")
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
                self.getInitialInfoDelegate?.onGetAdsResult!(false, info: "获取广告失败")
            }
        }
    }
}

@objc protocol GetInitialInfoDelegate {
    optional func onGetMaintenanceTypeResult(result: Bool, info: String)
    optional func onGetFeeResult(result: Bool, info: String)
    optional func onGetMessageResult(result: Bool, info: String)
    optional func onGetAdsResult(result: Bool, info: String)
}