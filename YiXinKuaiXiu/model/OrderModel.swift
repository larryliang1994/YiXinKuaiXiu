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
    
    func publishOrder(order: Order, imgString: String) {
        let paramters = ["id": Config.Aid!, "tok": Config.VerifyCode!, "tpe": ((order.type?.rawValue)! + 1).toString(), "pic": imgString, "cmt": order.desc!, "wxg": order.mTypeID!, "adr": order.location!, "lot": order.locationInfo!.coordinate.longitude.description, "lat": order.locationInfo!.coordinate.latitude.description, "fe1": order.fee!]
        
        AlamofireUtil.doRequest(Urls.PublishOrder, parameters: paramters) { (result, response) in
            if result {
                let responseDic = UtilBox.convertStringToDictionary(response)
                
                if responseDic == nil {
                    self.orderDelegate?.onPublishOrderResult(false, info: "订单发布失败")
                    return
                }
                
                let json = JSON(responseDic!)
                
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
                print(response)
                let responseDic = UtilBox.convertStringToDictionary(response)
                
                if responseDic == nil {
                    self.orderDelegate?.onPullOrderListResult(false, info: "获取订单列表失败", orderList: [])
                    return
                }
                
                let json = JSON(responseDic!)
                
                let ret = json["ret"]
                
                if ret != nil && ret.count != 0 {
                    var orderList: [Order] = []
                    for index in 0 ... ret.count - 1 {
                        let orderJson = ret[index]
                        
                        let state = State(rawValue: orderJson["ste"].intValue)!
                        if pullType == .Done && state != .HasBeenRated {
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
                            image1Url: "http://tse2.mm.bing.net/th?id=OIP.M9265f275be9a36c548da144b7b0d8edeo0&pid=15.1",
                            image2Url: "http://tse2.mm.bing.net/th?id=OIP.M9265f275be9a36c548da144b7b0d8edeo0&pid=15.1",
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
                        
                        order.parts = []
                        
                        order.partFee = orderJson["fe3"].stringValue
                        
                        order.senderTotalNum = orderJson["cnt"].intValue
                        
                        let imgs = orderJson["pic"].stringValue.componentsSeparatedByString(",")
                        if imgs.count == 1 && imgs[0] != "" {
                            order.image1Url = Urls.OrderImgServer + order.senderID! + "/" + imgs[0] + ".jpg"
                            order.image2Url = nil
                        } else if imgs.count == 2 {
                            order.image1Url = Urls.OrderImgServer + order.senderID! + "/" + imgs[0] + ".jpg"
                            order.image2Url = Urls.OrderImgServer + order.senderID! + "/" + imgs[1] + ".jpg"
                        } else {
                            order.image1Url = nil
                            order.image2Url = nil
                        }
                        
                        if order.senderName == "" {
                            order.senderName = "姓名"
                        }
                        
                        order.payments = []
                        if order.type == .Normal {
                            order.payments?.append(Payment(name: "上门检查费", price: Float(order.fee!)!, paid: order.state != .NotPayFee))
                        }
                        if order.mFee != nil && order.mFee != "" && order.mFee != "0" {
                            order.payments?.append(Payment(name: "维修费", price: Float(order.mFee!)!, paid: true))
                        }
                        if order.type == .Pack {
                            order.payments?.append(Payment(name: "打包维修费", price: Float(order.fee!)!, paid: order.state == .PaidMFee))
                        }
                        if order.partFee != nil && order.partFee != "" && order.partFee != "0" {
                            order.payments?.append(Payment(name: "配件费", price: Float(order.partFee!)!, paid: true))
                        }
                        
                        let partsString = orderJson["co3"].stringValue.stringByReplacingOccurrencesOfString("&quot;", withString: "\"")
                        
                        if partsString != "" {
                            let partDetailDic = UtilBox.convertStringToDictionary(partsString)
                            
                            if partDetailDic == nil {
                                continue
                            }
                            
                            let partDetailJson = JSON(partDetailDic!)["val"]
                            
                            if partDetailJson != "" && partDetailJson.count != 0 {
                                var parts: [Part] = []
                                for var index in 0...partDetailJson.count-1 {
                                    parts.append(Part(
                                        name: partDetailJson[index]["nme"].stringValue,
                                        num: partDetailJson[index]["num"].intValue,
                                        price: String(partDetailJson[index]["prs"].floatValue)))
                                }
                                order.parts = parts
                            }
                        }
                        
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
    
    func pullGrabOrderList(requestTime: String, fromDistance: Int?, toDistance: Int?) {
//        let paramters = ["id": Config.Aid!, "tok": Config.VerifyCode!, "dis": (fromDistance == nil ? "" : fromDistance!.toString()), "dit": (toDistance == nil ? "" : toDistance!.toString()), "dts": "", "dte": "", "stt": "", "cnt": ""]
        
        let paramters = ["id": Config.Aid!, "tok": Config.VerifyCode!, "dis": "", "dit": "", "dts": "", "dte": "", "stt": "", "cnt": ""]
        
        AlamofireUtil.doRequest(Urls.PullGrabOrderList, parameters: paramters) { (result, response) in
            if result {
                let responseDic = UtilBox.convertStringToDictionary(response)
                
                if responseDic == nil {
                    self.orderDelegate?.onPullGrabOrderListResult(false, info: "获取订单列表失败", orderList: [])
                    return
                }
                
                let json = JSON(responseDic!)
                
                let ret = json["ret"]
                
                if ret != nil && ret.count != 0 {
                    var orderList: [Order] = []
                    for index in 0 ... ret.count - 1 {
                        let orderJson = ret[index]
                        
                        let location = CLLocation(latitude: CLLocationDegrees(orderJson["lat"].doubleValue), longitude: CLLocationDegrees(orderJson["lot"].doubleValue))
                        
                        let desc = orderJson["cmt"].stringValue
                        
                        let order = Order(
                            date: orderJson["dte"].stringValue,
                            senderID: orderJson["aid"].stringValue,
                            senderName: orderJson["anm"].stringValue,
                            senderNum: orderJson["aph"].stringValue,
                            type: Type(rawValue: orderJson["tpe"].intValue - 1)!,
                            image1Url: "http://tse2.mm.bing.net/th?id=OIP.M9265f275be9a36c548da144b7b0d8edeo0&pid=15.1",
                            image2Url: "http://tse2.mm.bing.net/th?id=OIP.M9265f275be9a36c548da144b7b0d8edeo0&pid=15.1",
                            desc: desc == "" ? "无" : desc,
                            mTypeID: orderJson["wxg"].stringValue,
                            mType: UtilBox.findMTypeNameByID(orderJson["wxg"].stringValue)!,
                            location: orderJson["adr"].stringValue,
                            locationInfo: location,
                            fee: orderJson["fe1"].stringValue)
                        
                        let imgs = orderJson["pic"].stringValue.componentsSeparatedByString(",")
                        if imgs.count == 1 && imgs[0] != "" {
                            order.image1Url = Urls.OrderImgServer + order.senderID! + "/" + imgs[0] + ".jpg"
                            order.image2Url = nil
                        } else if imgs.count == 2 {
                            order.image1Url = Urls.OrderImgServer + order.senderID! + "/" + imgs[0] + ".jpg"
                            order.image2Url = Urls.OrderImgServer + order.senderID! + "/" + imgs[1] + ".jpg"
                        } else {
                            order.image1Url = nil
                            order.image2Url = nil
                        }

                        order.parts = []
                        
                        var distance: CLLocationDistance?
                        if Config.CurrentLocationInfo == nil {
                            distance = BMKMetersBetweenMapPoints(
                                BMKMapPointForCoordinate(order.locationInfo!.coordinate),
                                BMKMapPointForCoordinate(Config.LocationInfo!.coordinate))
                        } else {
                            distance = BMKMetersBetweenMapPoints(
                                BMKMapPointForCoordinate(order.locationInfo!.coordinate),
                                BMKMapPointForCoordinate(Config.CurrentLocationInfo!.coordinate))
                        }
                        
                        order.distance = Int(distance!/1000)
                        
                        if fromDistance == nil && toDistance == nil {
                            orderList.append(order)
                        } else {
                            if fromDistance == 30 && order.distance > 30 {
                                orderList.append(order)
                            } else if fromDistance < order.distance && order.distance <= toDistance {
                                orderList.append(order)
                            }
                        }
                        
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
                let responseDic = UtilBox.convertStringToDictionary(response)
                
                if responseDic == nil {
                    self.orderDelegate?.onGrabOrderResult(false, info: "抢单失败")
                    return
                }
                
                let json = JSON(responseDic!)
                
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
                let responseDic = UtilBox.convertStringToDictionary(response)
                
                if responseDic == nil {
                    self.orderDelegate?.onCancelOrderResult(false, info: "取消失败")
                    return
                }
                
                let json = JSON(responseDic!)
                
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