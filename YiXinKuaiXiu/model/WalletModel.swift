//
//  WalletModel.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/5/12.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import Foundation
import SwiftyJSON

class WalletModel: WalletProtocol {
    var walletDelegate: WalletDelegate?
    
    init(walletDelegate: WalletDelegate) {
        self.walletDelegate = walletDelegate
    }
    
    func doWithDraw(money: String, pwd: String) {
        AlamofireUtil.doRequest(Urls.WithDraw, parameters: ["id": Config.Aid!, "tok": Config.VerifyCode!, "cnt": money, "pwd": pwd]) { (result, response) in
            if result {
                let json = JSON(UtilBox.convertStringToDictionary(response)!)
                
                let ret = json["ret"].intValue
                
                if ret == 0 {
                    self.walletDelegate?.onWithDrawResult(true, info: "")
                } else if ret == 1 {
                    self.walletDelegate?.onWithDrawResult(false, info: "认证失败")
                } else if ret == 2 {
                    self.walletDelegate?.onWithDrawResult(false, info: "未设置提现银行信息")
                } else if ret == 3 {
                    self.walletDelegate?.onWithDrawResult(false, info: "余额不足")
                }
                
            } else {
                self.walletDelegate?.onWithDrawResult(false, info: "提现失败")
            }
        }
    }
    
    func doGetD2DAccount() {
        AlamofireUtil.doRequest(Urls.GetD2DAccount, parameters: ["id": Config.Aid!, "tok": Config.VerifyCode!]) { (result, response) in
            if result {
                let json = JSON(UtilBox.convertStringToDictionary(response)!)
                
                let ret = json["ret"]
                var accountList: [D2DAccount] = []
                
                if ret != nil {
                    
                    for index in 0 ... ret.count - 1 {
                        let account = D2DAccount(id: ret[index]["id"].intValue, week: UtilBox.stringToWeek(ret[index]["dte"].stringValue), date: ret[index]["dte"].stringValue, fee: ret[index]["num"].stringValue + ".00", type: ret[index]["cmt"].stringValue, status: ret[index]["ste"].intValue)
                        
                        accountList.append(account)
                    }
                }
                
                self.walletDelegate?.onGetD2DAccountResult(true, info: "", accountList: accountList)
            } else {
                self.walletDelegate?.onGetD2DAccountResult(false, info: "获取消息列表失败", accountList: [])
            }
        }
    }
}

protocol WalletDelegate {
    func onWithDrawResult(result: Bool, info: String)
    func onGetD2DAccountResult(result: Bool, info: String, accountList: [D2DAccount])
}