//
//  ReceiptModel.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/6/16.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import Foundation
import SwiftyJSON

class ReceiptModel: ReceiptProtocol {
    var receiptDelegate: ReceiptDelegate?
    
    init(receiptDelegate: ReceiptDelegate) {
        self.receiptDelegate = receiptDelegate
    }
    
    func getReceiptList() {
        AlamofireUtil.doRequest(Urls.GetReceiptList, parameters: ["id": Config.Aid!, "tok": Config.VerifyCode!]) { (result, response) in
            if result {
                let responseDic = UtilBox.convertStringToDictionary(response)
                
                if responseDic == nil {
                    UtilBox.reportBug(response)
                    self.receiptDelegate?.onGetReceiptListResult!(false, info: "获取发票失败")
                    return
                }
                
                let json = JSON(responseDic!)
                
                let ret = json["ret"]
                
                if ret != nil && ret.count != 0 {
                    
                    Config.ReceiptList = []
                    for index in 0 ... ret.count - 1 {
                        let receiptJson = ret[index]
                        
                        let receipt = Receipt(
                            title: receiptJson["tit"].stringValue,
                            fee: receiptJson["num"].stringValue,
                            desc: receiptJson["cmt"].stringValue,
                            state: ReceiptState(rawValue: receiptJson["ste"].intValue)!,
                            reason: receiptJson["res"].stringValue,
                            date: receiptJson["dte"].stringValue)
                        
                        Config.ReceiptList.append(receipt)
                    }
                    
                }
                
                self.receiptDelegate?.onGetReceiptListResult!(true, info: "")
            } else {
                self.receiptDelegate?.onGetReceiptListResult!(false, info: "获取发票失败")
            }
        }

    }
    
    func invoice(title: String, fee: String, desc: String) {
        let paramters = ["id": Config.Aid!, "tok": Config.VerifyCode!, "tit": title, "num": fee, "cmt": desc]
        AlamofireUtil.doRequest(Urls.Invoice, parameters: paramters, callback: { (result, response) in
            if result {
                let responseDic = UtilBox.convertStringToDictionary(response)
                
                if responseDic == nil {
                    UtilBox.reportBug(response)
                    self.receiptDelegate?.onInvoiceResult!(false, info: "申请失败")
                    return
                }
                
                let json = JSON(responseDic!)
                
                let ret = json["ret"].intValue
                
                if ret == 0 {
                    self.receiptDelegate?.onInvoiceResult!(true, info: "")
                } else if ret == 1 {
                    self.receiptDelegate?.onInvoiceResult!(false, info: "认证失败")
                } else if ret == 2 {
                    self.receiptDelegate?.onInvoiceResult!(false, info: "参数错误")
                }
            } else {
                self.receiptDelegate?.onInvoiceResult!(false, info: "申请失败")
            }
        })
    }
}

@objc protocol ReceiptDelegate {
    optional func onGetReceiptListResult(result: Bool, info: String)
    optional func onInvoiceResult(result: Bool, info: String)
}