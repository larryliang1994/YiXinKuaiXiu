//
//  PayModel.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/5/13.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

public enum PayType: Int {
    case Fee = 1
    case MPFee = 3
}

class PayModel: PayProtocol, PayDelegate {
    var payDelegate: PayDelegate?
    
    init(payDelegate: PayDelegate) {
        self.payDelegate = payDelegate
    }
    
    func goPay(date: String, type: PayType, fee: String) {
        AlamofireUtil.doRequest(Urls.GoPay, parameters: ["id": Config.Aid!, "tok": Config.VerifyCode!, "dte": date, "tpe": type.rawValue.toString(), "fee": fee]) { (result, response) in
            if result {
                let responseDic = UtilBox.convertStringToDictionary(response)
                
                if responseDic == nil {
                    UtilBox.reportBug(response)
                    self.payDelegate?.onGoPayResult!(false, info: "支付失败")
                    return
                }
                
                let json = JSON(responseDic!)
                
                let ret = json["ret"].intValue
                
                var info = ""
                switch ret {
                case 0:
                    self.payDelegate?.onGoPayResult!(true, info: "")
                    return
                case 1: info = "认证失败"
                case 2: info = "没有该订单"
                case 3: info = "已支付过"
                case 4: info = "参数错误"
                case 5: info = "余额不足"
                case 6: info = "金额不匹配"
                default: info = "失败"
                }
                
                self.payDelegate?.onGoPayResult!(false, info: info)
            } else {
                self.payDelegate?.onGoPayResult!(false, info: "支付失败")
            }
        }
    }
    
//    func goRecharge(fee: String) {
//        let parameters = ["id": Config.Aid!, "tok": Config.VerifyCode!, "act": "tst", "out_trade_no": Config.Aid! + "_" + NSDate().timeIntervalSince1970.description, "trade_no": "123456", "total_fee": fee]
//        
//        var requestUrl = Urls.Recharge
//        
//        for (key, value) in parameters {
//            requestUrl += key + "=" + value + "&"
//        }
//        
//        requestUrl = requestUrl.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLFragmentAllowedCharacterSet())!
//        
//        print(requestUrl)
//        
//        request(.GET, requestUrl)
//            .responseString{ response in
//                if response.result.isSuccess {
//                    print(response.result.value!)
//                    if response.result.value! == "success" {
//                        self.payDelegate?.onGoRechargeResult!(true, info: "")
//                    } else {
//                        UtilBox.reportBug(response.result.value!)
//                        self.payDelegate?.onGoRechargeResult!(false, info: "充值失败")
//                    }
//                } else {
//                    self.payDelegate?.onGoRechargeResult!(false, info: "充值失败")
//                }
//        }
//    }
    
    func getBillNumber(fee: String) {
        let parameters = ["id": Config.Aid!, "tok": Config.VerifyCode!, "cnt": fee]
        AlamofireUtil.doRequest(Urls.GetBillNumber, parameters: parameters) { (result, response) in
            if result {
                print(response)
                let responseDic = UtilBox.convertStringToDictionary(response)
                
                if responseDic == nil {
                    UtilBox.reportBug(response)
                    self.payDelegate?.onGetBillNumberResult!(false, info: "支付失败")
                    return
                }
                
                let json = JSON(responseDic!)
                
                let ret = json["ret"].intValue
                
                if ret == 0 {
                    let ddh = json["ddh"].stringValue
                    if ddh.containsString("_") {
                        self.payDelegate?.onGetBillNumberResult!(true, info: ddh.componentsSeparatedByString("_")[1])
                    } else {
                        self.payDelegate?.onGetBillNumberResult!(true, info: ddh)
                    }
                } else if ret == 1 {
                    self.payDelegate?.onGetBillNumberResult!(false, info: "认证失败")
                }
            } else {
                self.payDelegate?.onGetBillNumberResult!(false, info: "支付失败")
            }
        }
    }
    
    func goPayParts(date: String, detail: String, fee: String) {
        let parameters = ["id": Config.Aid!, "tok": Config.VerifyCode!, "dte": date, "con": detail, "fee": fee]
        AlamofireUtil.doRequest(Urls.PayParts, parameters: parameters) { (result, response) in
            if result {
                let responseDic = UtilBox.convertStringToDictionary(response)
                
                if responseDic == nil {
                    UtilBox.reportBug(response)
                    self.payDelegate?.onGoPayPartsResult!(false, info: "支付失败")
                    return
                }
                
                let json = JSON(responseDic!)
                
                let ret = json["ret"].intValue
                
                if ret == 0 {
                    self.payDelegate?.onGoPayPartsResult!(true, info: "")
                } else if ret == 1 {
                    self.payDelegate?.onGoPayPartsResult!(false, info: "认证失败")
                } else if ret == 2 {
                    self.payDelegate?.onGoPayPartsResult!(false, info: "订单不存在")
                } else if ret == 3 {
                    self.payDelegate?.onGoPayPartsResult!(false, info: "无法修改")
                } else if ret == 4 {
                    self.payDelegate?.onGoPayPartsResult!(false, info: "失败")
                } else if ret == 5 {
                    self.payDelegate?.onGoPayPartsResult!(false, info: "余额不足")
                }
            } else {
                self.payDelegate?.onGoPayPartsResult!(false, info: "支付失败")
            }
        }
    }
    
    func goPayMFee(date: String, fee: String) {
        let parameters = ["id": Config.Aid!, "tok": Config.VerifyCode!, "dte": date, "fee": fee]
        AlamofireUtil.doRequest(Urls.PayMFee, parameters: parameters) { (result, response) in
            if result {
                let responseDic = UtilBox.convertStringToDictionary(response)
                
                if responseDic == nil {
                    UtilBox.reportBug(response)
                    self.payDelegate?.onGoPayMFeeResult!(false, info: "支付失败")
                    return
                }
                
                let json = JSON(responseDic!)
                
                let ret = json["ret"].intValue
                
                if ret == 0 {
                    PayModel(payDelegate: self).goPay(date, type: .MPFee, fee: fee)
                } else if ret == 1 {
                    self.payDelegate?.onGoPayMFeeResult!(false, info: "认证失败")
                } else if ret == 2 {
                    self.payDelegate?.onGoPayMFeeResult!(false, info: "订单不存在")
                } else if ret == 3 {
                    self.payDelegate?.onGoPayMFeeResult!(false, info: "无法修改")
                } else if ret == 4 {
                    self.payDelegate?.onGoPayMFeeResult!(false, info: "失败")
                }
            } else {
                self.payDelegate?.onGoPayMFeeResult!(false, info: "支付失败")
            }
        }
    }
    
    @objc func onGoPayResult(result: Bool, info: String) {
        if result {
            self.payDelegate?.onGoPayMFeeResult?(true, info: "")
        } else {
            self.payDelegate?.onGoPayMFeeResult?(false, info: info)
        }
    }
}

@objc protocol PayDelegate {
    optional func onGoPayResult(result: Bool, info: String)
    optional func onGoPayPartsResult(result: Bool, info: String)
    optional func onGoPayMFeeResult(result: Bool, info: String)
//    optional func onGoRechargeResult(result: Bool, info: String)
    optional func onGetBillNumberResult(result: Bool, info: String)
}