//
//  PayModel.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/5/13.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import Foundation
import SwiftyJSON

public enum PayType: Int {
    case Fee = 1
    case MFee = 3
    case Part = 4
}

class PayModel: PayProtocol, PayDelegate {
    var payDelegate: PayDelegate?
    
    init(payDelegate: PayDelegate) {
        self.payDelegate = payDelegate
    }
    
    func goPay(date: String, type: PayType, fee: String) {
        AlamofireUtil.doRequest(Urls.GoPay, parameters: ["id": Config.Aid!, "tok": Config.VerifyCode!, "dte": date, "tpe": type.rawValue.toString(), "fee": fee]) { (result, response) in
            if result {
                print(response)
                let json = JSON(UtilBox.convertStringToDictionary(response)!)
                
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
    
    func goPayParts(date: String, detail: String, fee: String) {
        let parameters = ["id": Config.Aid!, "tok": Config.VerifyCode!, "dte": date, "con": detail, "fee": fee]
        AlamofireUtil.doRequest(Urls.PayParts, parameters: parameters) { (result, response) in
            if result {
                print(response)
                let json = JSON(UtilBox.convertStringToDictionary(response)!)
                
                let ret = json["ret"].intValue
                
                if ret == 0 {
                    PayModel(payDelegate: self).goPay(date, type: .Part, fee: fee)
                } else if ret == 1 {
                    self.payDelegate?.onGoPayPartsResult!(false, info: "认证失败")
                } else if ret == 2 {
                    self.payDelegate?.onGoPayPartsResult!(false, info: "订单不存在")
                } else if ret == 3 {
                    self.payDelegate?.onGoPayPartsResult!(false, info: "无法修改")
                } else if ret == 4 {
                    self.payDelegate?.onGoPayPartsResult!(false, info: "失败")
                }
            } else {
                self.payDelegate?.onGoPayPartsResult!(false, info: "支付失败")
            }
        }
    }
    
    @objc func onGoPayResult(result: Bool, info: String) {
        if result {
            self.payDelegate?.onGoPayPartsResult!(true, info: "")
        } else {
            self.payDelegate?.onGoPayPartsResult!(false, info: info)
        }
    }
}

@objc protocol PayDelegate {
    optional func onGoPayResult(result: Bool, info: String)
    optional func onGoPayPartsResult(result: Bool, info: String)
}