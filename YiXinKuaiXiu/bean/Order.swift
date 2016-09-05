//
//  Order.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/22.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import Foundation
import Photos

public enum Type: Int {
    case Urgent = 0
    case Pack
    case Reservation
}

/**
 * 订单流程：
 * 未支付上门费 —— 待发单 —— 去支付
 * 已支付上门费 —— 待抢单 —— 无
 * 已被抢单    —— 进行中 —— 购买配件 + 竣工付费
 * 已竣工付费 —— 待评价 —— 补购配件 + 去评价
 * 已支付配件费
 * 已支付全部费用
 * 已评价      —— 已完成 —— 无
 * 取消中      —— 申请取消中 —— 无
 **/

public enum Status: Int {
    case ToBeBilled = 0 // 待发单
    case ToBeGrabbed    // 待抢单
    case OnGoing        // 进行中
    case ToBeRating     // 待评价
    case Done           // 已完成
    case Cancelling     // 申请取消中
}

public enum State: Int {
    case Cancelling = -1    // 取消中
    case NotPayFee = 0  // 未支付上门费
    case PaidFee        // 已支付上门费
    case HasBeenGrabbed // 已被抢单
    case PaidMFee       // 已竣工付费
    case HasBeenRated   // 已评价
}

class Order {
    var type: Type?
    var desc: String?
    var mType: String?
    var mTypeID: String?
    var location: String?
    var locationInfo: CLLocation?
    var fee: String?
    var mFee: String?
    var images: [DKAsset]?
    
    var status: Status?
    var state: State?
    var ratingStar: Int?
    var ratingDesc: String?
    
    var parts: [Part]?
    
    var partFee: String?
    
    var payments: [Payment]?
    
    var id: String?
    var date: String?
    var senderID: String?
    var senderName: String?
    var senderNum: String?
    var graberID: String?
    var imageUrls: [String]?
    
    var distance: Int?
    
    var senderTotalNum: Int?
    
    init(type: Type, desc: String, mType: String, mTypeID: String, location: String, locationInfo: CLLocation, fee: String?, images: [DKAsset]?) {
        self.type = type
        self.desc = desc
        self.mType = mType
        self.mTypeID = mTypeID
        self.location = location
        self.locationInfo = locationInfo
        self.fee = fee
        self.images = images
    }
    
    init(type: Type, desc: String, mType: String, mTypeID: String, location: String, locationInfo: CLLocation, fee: String?, images: [DKAsset]?, status: Status, ratingStar: Int?, ratingDesc: String?, parts: [Part]?, payments: [Payment]) {
        self.type = type
        self.desc = desc
        self.mType = mType
        self.mTypeID = mTypeID
        self.location = location
        self.locationInfo = locationInfo
        self.fee = fee
        self.images = images
        self.status = status
        self.ratingStar = ratingStar
        self.ratingDesc = ratingDesc
        self.parts = parts
        self.payments = payments
    }
    
    // 订单列表构造
    init(id: String, date: String, senderID: String, senderName: String, senderNum: String, graberID: String, type: Type, imageUrls: [String]?, desc: String, mTypeID: String, mType: String, location: String, locationInfo: CLLocation, fee: String, mFee: String, status: Status, state: State, ratingStar: Int?, ratingDesc: String?) {
        self.id = id
        self.date = date
        self.senderID = senderID
        self.senderName = senderName
        self.senderNum = senderNum
        self.graberID = graberID
        self.type = type
        self.imageUrls = imageUrls
        self.desc = desc
        self.mTypeID = mTypeID
        self.mType = mType
        self.location = location
        self.locationInfo = locationInfo
        self.fee = fee
        self.mFee = mFee
        self.status = status
        self.state = state
        self.ratingStar = ratingStar
        self.ratingDesc = ratingDesc
    }
    
    // 抢单列表构造
    init(date: String, senderID: String, senderName: String, senderNum: String, type: Type, imageUrls: [String]?, desc: String, mTypeID: String, mType: String, location: String, locationInfo: CLLocation, fee: String) {
        self.date = date
        self.senderID = senderID
        self.senderName = senderName
        self.senderNum = senderNum
        self.type = type
        self.imageUrls = imageUrls
        self.desc = desc
        self.mTypeID = mTypeID
        self.mType = mType
        self.location = location
        self.locationInfo = locationInfo
        self.fee = fee
    }
}