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
        let paramters = ["id": Config.Aid!, "tok": Config.VerifyCode!, "tpe": ((order.type?.rawValue)! + 1).toString(), "pic": "", "cmt": order.desc!, "wxg": order.mTypeID!, "adr": order.location!, "lot": order.locationInfo!.coordinate.longitude.description, "lat": order.locationInfo!.coordinate.latitude.description, "fe1": order.fee!]
        
        AlamofireUtil.doRequest(Urls.PublishOrder, parameters: paramters) { (result, response) in
            if result {
                let json = JSON(UtilBox.convertStringToDictionary(response)!)
                
                let ret = json["ret"].intValue
                
                if ret == 0 {
                    self.orderDelegate?.onPublishOrderResult(true, info: json["dte"].stringValue)
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
    
    func pullOrderList(requestTime: String, pullType: PullOrderListType) {
        let paramters = ["id": Config.Aid!, "tok": Config.VerifyCode!, "ste": pullType.rawValue.toString(), "dts": "", "dte": "", "stt": "", "cnt": ""]
        
        AlamofireUtil.doRequest(Config.Role == Constants.Role.Customer ? Urls.PullCustomerOrderList : Urls.PullHandymanOrderList, parameters: paramters) { (result, response) in
            if result {
                let json = JSON(UtilBox.convertStringToDictionary(response)!)
                
                let ret = json["ret"]
                
                if ret != nil && ret.count != 0 {
                    var orderList: [Order] = []
                    for index in 0 ... ret.count - 1 {
                        let orderJson = ret[index]
                        
                        let state = State(rawValue: orderJson["ste"].intValue)!
                        if pullType == .Done && state != .HasBeenRated {
                            continue
                        }
                        
                        if orderJson["wxg"].stringValue == "0" {
                            continue
                        }
                        
                        let location = CLLocation(latitude: CLLocationDegrees(orderJson["lat"].doubleValue), longitude: CLLocationDegrees(orderJson["lot"].doubleValue))
                        
                        let desc = orderJson["cmt"].stringValue
                        
                        let order = Order(
                            id: orderJson["id"].stringValue,
                            date: orderJson["dte"].stringValue,
                            senderID: orderJson["aid"].stringValue,
                            senderName: orderJson["anm"].stringValue,
                            senderNum: orderJson["aph"].stringValue,
                            graberID: orderJson["bid"].stringValue,
                            type:  Type(rawValue: orderJson["tpe"].intValue - 1)!,
                            image1Url: nil,
                            image2Url: nil,
                            desc: desc == "" ? "无" : desc,
                            mTypeID: orderJson["wxg"].stringValue,
                            mType: UtilBox.findMTypeNameByID(orderJson["wxg"].stringValue)!,
                            location: orderJson["adr"].stringValue,
                            locationInfo: location,
                            fee: orderJson["fe1"].stringValue,
                            mFee: orderJson["fe2"].stringValue,
                            status: Status(rawValue: (state.rawValue + 6) % 6)!,
                            state: state,
                            ratingStar: orderJson["fen"].intValue,
                            ratingDesc: orderJson["fem"].stringValue)
                        
                        order.payments = [Payment(name: "上门检查费", price: 10, paid: true), Payment(name: "六角螺母2.5*3mm x6", price: 10, paid: true)]
                        
                        orderList.append(order)
                    }
                    self.orderDelegate?.onPullOrderListResult(true, info: "", orderList: orderList)
                } else {
                    self.orderDelegate?.onPullOrderListResult(true, info: "", orderList: [])
                }
            } else {
                self.orderDelegate?.onPullOrderListResult(false, info: "获取订单列表失败", orderList: [])
            }
        }
    }
    
    func pullGrabOrderList(requestTime: String, distance: Int?) {
        let paramters = ["id": Config.Aid!, "tok": Config.VerifyCode!, "dis": (distance == nil ? "" : distance!.toString()), "dts": "", "dte": "", "stt": "", "cnt": ""]
        
        AlamofireUtil.doRequest(Urls.PullGrabOrderList, parameters: paramters) { (result, response) in
            if result {
                let json = JSON(UtilBox.convertStringToDictionary(response)!)
                
                let ret = json["ret"]
                
                if ret != nil && ret.count != 0 {
                    var orderList: [Order] = []
                    for index in 0 ... ret.count - 1 {
                        let orderJson = ret[index]
                        
                        if orderJson["wxg"].stringValue == "0" {
                            continue
                        }
                        
                        let location = CLLocation(latitude: CLLocationDegrees(orderJson["lat"].doubleValue), longitude: CLLocationDegrees(orderJson["lot"].doubleValue))
                        
                        let desc = orderJson["cmt"].stringValue
                        
                        let order = Order(
                            date: orderJson["dte"].stringValue,
                            senderID: orderJson["aid"].stringValue,
                            senderName: orderJson["anm"].stringValue,
                            senderNum: orderJson["aph"].stringValue,
                            type: Type(rawValue: orderJson["tpe"].intValue - 1)!,
                            imageUrl: orderJson["pic"].stringValue,
                            desc: desc == "" ? "无" : desc,
                            mTypeID: orderJson["wxg"].stringValue,
                            mType: UtilBox.findMTypeNameByID(orderJson["wxg"].stringValue)!,
                            location: orderJson["adr"].stringValue,
                            locationInfo: location,
                            fee: orderJson["fe1"].stringValue)
                        
                        orderList.append(order)
                    }
                    
                    self.orderDelegate?.onPullGrabOrderListResult(true, info: "", orderList: orderList)
                } else {
                    self.orderDelegate?.onPullGrabOrderListResult(true, info: "", orderList: [])
                }
            } else {
                self.orderDelegate?.onPullGrabOrderListResult(false, info: "获取订单列表失败", orderList: [])
            }
        }
    }
    
    func grabOrder(order: Order) {
        let parameters = ["id": Config.Aid!, "tok": Config.VerifyCode!, "dte": order.date!, "aid": order.senderID!]
        
        AlamofireUtil.doRequest(Urls.GrabOrder, parameters: parameters) { (result, response) in
            if result {
                let json = JSON(UtilBox.convertStringToDictionary(response)!)
                
                let ret = json["ret"].intValue
                
                if ret == 0 {
                    self.orderDelegate?.onGrabOrderResult(true, info: "")
                } else if ret == 1 {
                    self.orderDelegate?.onGrabOrderResult(false, info: "认证失败")
                } else if ret == 2 {
                    self.orderDelegate?.onGrabOrderResult(false, info: "抢单失败")
                }
            } else {
                self.orderDelegate?.onGrabOrderResult(false, info: "抢单失败")
            }
        }
    }
    
    func cancelOrder(order: Order) {
        let parameters = ["id": Config.Aid!, "tok": Config.VerifyCode!, "dte": order.date!]
        
        AlamofireUtil.doRequest(Urls.CancelOrder, parameters: parameters) { (result, response) in
            if result {
                let json = JSON(UtilBox.convertStringToDictionary(response)!)
                
                let ret = json["ret"].intValue
                
                if ret == 0 {
                    self.orderDelegate?.onCancelOrderResult(true, info: "")
                } else if ret == 1 {
                    self.orderDelegate?.onCancelOrderResult(false, info: "认证失败")
                } else if ret == 2 {
                    self.orderDelegate?.onCancelOrderResult(false, info: "订单不存在")
                } else if ret == 3 {
                    self.orderDelegate?.onCancelOrderResult(false, info: "订单已完成")
                } else if ret == 4 {
                    self.orderDelegate?.onCancelOrderResult(false, info: "失败")
                }
            } else {
                self.orderDelegate?.onCancelOrderResult(false, info: "取消失败")
            }
        }
    }
    
    func cancelOrderConfirm(order: Order, confirm: Bool) {
        let parameters = ["id": Config.Aid!, "tok": Config.VerifyCode!, "dte": order.date!, "cmd": confirm ? "0" : "1"]
        
        AlamofireUtil.doRequest(Urls.CancelOrderConfirm, parameters: parameters) { (result, response) in
            if result {
                let json = JSON(UtilBox.convertStringToDictionary(response)!)
                
                let ret = json["ret"].intValue
                
                if ret == 0 {
                    self.orderDelegate?.onCancelOrderConfirmResult(true, info: "")
                } else if ret == 1 {
                    self.orderDelegate?.onCancelOrderConfirmResult(false, info: "认证失败")
                } else if ret == 2 {
                    self.orderDelegate?.onCancelOrderConfirmResult(false, info: "订单不存在")
                } else if ret == 3 {
                    self.orderDelegate?.onCancelOrderConfirmResult(false, info: "订单已完成")
                } else if ret == 4 {
                    self.orderDelegate?.onCancelOrderConfirmResult(false, info: "失败")
                }
            } else {
                self.orderDelegate?.onCancelOrderConfirmResult(false, info: "失败")
            }
        }
    }
}

protocol OrderDelegate {
    func onPublishOrderResult(result: Bool, info: String)
    func onPullOrderListResult(result: Bool, info: String, orderList: [Order])
    func onPullGrabOrderListResult(result: Bool, info: String, orderList: [Order])
    func onGrabOrderResult(result: Bool, info: String)
    func onCancelOrderResult(result: Bool, info: String)
    func onCancelOrderConfirmResult(result: Bool, info: String)
}