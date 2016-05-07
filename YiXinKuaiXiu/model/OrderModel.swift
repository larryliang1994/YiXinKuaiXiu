//
//  OrderModel.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/5/4.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import Foundation
import SwiftyJSON

class OrderModel: OrderProtocol {
    var orderDelegate: OrderDelegate?
    
    init(orderDelegate: OrderDelegate) {
        self.orderDelegate = orderDelegate
    }
    
    func publishOrder(order: Order) {
        let paramters = ["id": Config.Aid!, "tok": Config.VerifyCode!, "tpe": ((order.type?.rawValue)! + 1).toString(), "pic": "", "cmt": order.desc!, "wxg": order.mTypeID!, "adr": order.location!, "lot": order.locationInfo!.coordinate.longitude.description, "lat": order.locationInfo!.coordinate.latitude.description]
        
        AlamofireUtil.doRequest(Urls.PublishOrder, parameters: paramters) { (result, response) in
            if result {
                let json = JSON(UtilBox.convertStringToDictionary(response)!)
                
                let ret = json["ret"].intValue
                
                if ret == 0 {
                    self.orderDelegate?.onPublishOrderResult(true, info: "")
                } else if ret == 1 {
                    self.orderDelegate?.onPublishOrderResult(false, info: "认证失败")
                } else if ret == 2 {
                    self.orderDelegate?.onPublishOrderResult(false, info: "参数错误")
                } else if ret == 3 {
                    self.orderDelegate?.onPublishOrderResult(false, info: "失败")
                } else if ret == 4 {
                    self.orderDelegate?.onPublishOrderResult(false, info: "短时间内不要重复发布")
                }
                
            } else {
                self.orderDelegate?.onPublishOrderResult(false, info: "订单发布失败")
            }
        }
    }
    
    func pullOrderList(requestTime: String, type: PullOrderListType) {
        let paramters = ["dts": "", "dte": "", "stt": "", "cnt": "8"]
        
        AlamofireUtil.doRequest(Urls.PullOrderList, parameters: paramters) { (result, response) in
            if result {
                let json = JSON(UtilBox.convertStringToDictionary(response)!)
                
                let ret = json["ret"]
                
                print(ret)
                
//                if ret != nil {
//                    
//                    for index in 0 ... ret.count - 1 {
//                        let orderJson = ret[index]
//                        
//                    }
//                    
//                }
            } else {
                self.orderDelegate?.onPullOrderListResult(false, info: "获取订单列表失败")
            }
        }
    }
}

protocol OrderDelegate {
    func onPublishOrderResult(result: Bool, info: String)
    func onPullOrderListResult(result: Bool, info: String)
}