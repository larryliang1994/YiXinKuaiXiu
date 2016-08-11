//
//  OrderModel.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/5/4.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import Foundation
import SwiftyJSON

class OrderModel: OrderProtocol, UploadImageDelegate {
    var orderDelegate: OrderDelegate?
    var order: Order?
    
    init(orderDelegate: OrderDelegate) {
        self.orderDelegate = orderDelegate
    }
    
    func publish(order: Order) {
        self.order = order
        if order.images != nil && order.images?.count != 0 {
            UploadImageModel(uploadImageDelegate: self).uploadImages(order.images!)
        } else {
            publishOrder(order, imgString: "")
        }
    }
    
    @objc func onUploadImagesResult(result: Bool, info: String) {
        if result {
            publishOrder(order!, imgString: info)
        } else {
            self.orderDelegate?.onPublishOrderResult(false, info: "订单发布失败")
        }
    }
    
    func publishOrder(order: Order, imgString: String) {
        let paramters = ["id": Config.Aid!, "tok": Config.VerifyCode!, "tpe": ((order.type?.rawValue)! + 1).toString(), "pic": imgString, "cmt": order.desc!, "wxg": order.mTypeID!, "adr": order.location!, "lot": order.locationInfo!.coordinate.longitude.description, "lat": order.locationInfo!.coordinate.latitude.description, "fe1": order.fee!]
        
        AlamofireUtil.doRequest(Urls.PublishOrder, parameters: paramters) { (result, response) in
            if result {
                let responseDic = UtilBox.convertStringToDictionary(response)
                
                if responseDic == nil {
                    UtilBox.reportBug(response)
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
    
    func pullOrderList(requestIndex: Int, pullType: PullOrderListType) {
        let paramters = ["id": Config.Aid!, "tok": Config.VerifyCode!, "ste": pullType.rawValue.toString(), "dts": "", "dte": "", "stt": "", "cnt": ""]
        
        AlamofireUtil.doRequest(Config.Role == Constants.Role.Customer ? Urls.PullCustomerOrderList : Urls.PullHandymanOrderList, parameters: paramters) { (result, response) in
            if result {
                let responseDic = UtilBox.convertStringToDictionary(response)
                
                if responseDic == nil {
                    UtilBox.reportBug(response)
                    self.orderDelegate?.onPullOrderListResult(false, info: "获取订单列表失败,请重试", orderList: [])
                    return
                }
                
                // 为了不让已经抢了紧急单的师傅再抢紧急单
                if Config.Role! == Constants.Role.Handyman {
                    Config.canGrabUrgentOrder = true
                }
                
                print(response)
                
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
                        
                        let type = orderJson["tpe"].intValue
                        
                        let order = Order(
                            id: orderJson["id"].stringValue,
                            date: orderJson["dte"].stringValue,
                            senderID: orderJson["aid"].stringValue,
                            senderName: orderJson["anm"].stringValue,
                            senderNum: orderJson["aph"].stringValue,
                            graberID: orderJson["bid"].stringValue,
                            type: Type(rawValue: orderJson["tpe"].intValue - 1)!,
                            imageUrls: [],
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
                        for var index in 0...imgs.count-1 {
                            if imgs[index] != "" {
                                order.imageUrls?.append(Urls.OrderImgServer + order.senderID! + "/" + imgs[index] + ".jpg")
                            }
                        }
                        
                        if order.senderName == "" {
                            order.senderName = "姓名"
                        }
                        
                        order.payments = []
                        if order.type == .Urgent {
                            order.payments?.append(Payment(name: "紧急检查费", price: Float(order.fee!)!, paid: order.state != .NotPayFee))
                            if Config.Role! == Constants.Role.Handyman {
                                Config.canGrabUrgentOrder = false
                            }
                        }
                        if order.mFee != nil && order.mFee != "" && order.mFee != "0" {
                            order.payments?.append(Payment(name: "维修费", price: Float(order.mFee!)!, paid: true))
                        }
                        if order.type == .Pack {
                            order.payments?.append(Payment(name: "打包费", price: Float(order.fee!)!, paid: order.state == .PaidMFee))
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
                                        price: String(partDetailJson[index]["prs"].floatValue),
                                        desc: ""))
                                }
                                order.parts = parts
                            }
                        }
                        
                        orderList.append(order)
                    }
                    self.orderDelegate?.onPullOrderListResult(true, info: requestIndex.toString(), orderList: orderList)
                } else {
                    self.orderDelegate?.onPullOrderListResult(true, info: requestIndex.toString(), orderList: [])
                }
            } else {
                self.orderDelegate?.onPullOrderListResult(false, info: "获取订单列表失败", orderList: [])
            }
        }
    }
    
    func pullGrabOrderList(requestTime: String, fromDistance: Int?, toDistance: Int?) {
        let paramters = ["id": Config.Aid!, "tok": Config.VerifyCode!, "dis": "", "dit": "", "dts": "", "dte": "", "stt": "", "cnt": ""]
        
        AlamofireUtil.doRequest(Urls.PullGrabOrderList, parameters: paramters) { (result, response) in
            if result {
                let responseDic = UtilBox.convertStringToDictionary(response)
                
                if responseDic == nil {
                    UtilBox.reportBug(response)
                    self.orderDelegate?.onPullGrabOrderListResult(false, info: "获取订单列表失败", orderList: [])
                    return
                }
                
                print(response)
                
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
                            imageUrls: [],
                            desc: desc == "" ? "无" : desc,
                            mTypeID: orderJson["wxg"].stringValue,
                            mType: UtilBox.findMTypeNameByID(orderJson["wxg"].stringValue)!,
                            location: orderJson["adr"].stringValue,
                            locationInfo: location,
                            fee: orderJson["fe1"].stringValue)
                        
                        let imgs = orderJson["pic"].stringValue.componentsSeparatedByString(",")
                        for var index in 0...imgs.count-1 {
                            if imgs[index] != "" {
                                order.imageUrls?.append(Urls.OrderImgServer + order.senderID! + "/" + imgs[index] + ".jpg")
                            }
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
                    UtilBox.reportBug(response)
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
                    UtilBox.reportBug(response)
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
                
                let responseDic = UtilBox.convertStringToDictionary(response)
                
                if responseDic == nil {
                    UtilBox.reportBug(response)
                    self.orderDelegate?.onCancelOrderResult(false, info: "失败")
                    return
                }
                
                let json = JSON(responseDic!)
                
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