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
    case Normal = 0
    case Pack
    case Reservation
}

public enum Status: Int {
    case ToBeBilled = 0
    case OnGoing
    case BeingCancelled
    case Cancelling
    case ToBeRating
    case ToBeGrabbed
    case Done
}

class Order {
    var type: Type?
    var desc: String?
    var mType: String?
    var mTypeID: String?
    var location: String?
    var locationInfo: CLLocation?
    var fee: String?
    var image1: DKAsset?
    var image2: DKAsset?
    
    var status: Status?
    var ratingStar: Int?
    var ratingDesc: String?
    
    var parts: [Part]?
    
    var payments: [Payment]?
    
    var id: String?
    var date: String?
    var senderID: String?
    var senderName: String?
    var senderNum: String?
    var graberID: String?
    var image1Url: String?
    var image2Url: String?
    
    init(type: Type, desc: String, mType: String, mTypeID: String, location: String, locationInfo: CLLocation, fee: String?, image1: DKAsset?, image2: DKAsset?) {
        self.type = type
        self.desc = desc
        self.mType = mType
        self.mTypeID = mTypeID
        self.location = location
        self.locationInfo = locationInfo
        self.fee = fee
        self.image1 = image1
        self.image2 = image2
    }
    
    init(type: Type, desc: String, mType: String, mTypeID: String, location: String, locationInfo: CLLocation, fee: String?, image1: DKAsset?, image2: DKAsset?, status: Status, ratingStar: Int?, ratingDesc: String?, parts: [Part]?, payments: [Payment]) {
        self.type = type
        self.desc = desc
        self.mType = mType
        self.mTypeID = mTypeID
        self.location = location
        self.locationInfo = locationInfo
        self.fee = fee
        self.image1 = image1
        self.image2 = image2
        self.status = status
        self.ratingStar = ratingStar
        self.ratingDesc = ratingDesc
        self.parts = parts
        self.payments = payments
    }
    
    init(id: String, date: String, senderID: String, senderName: String, senderNum: String, graberID: String, type: Type, image1Url: String?, image2Url: String?, desc: String, mTypeID: String, location: String, locationInfo: CLLocation, fee: String, status: Status, ratingStar: Int?, ratingDesc: String?) {
        self.id = id
        self.date = date
        self.senderID = senderID
        self.senderName = senderName
        self.senderNum = senderNum
        self.graberID = graberID
        self.type = type
        self.image1Url = image1Url
        self.image2Url = image2Url
        self.desc = desc
        self.mTypeID = mTypeID
        self.location = location
        self.locationInfo = locationInfo
        self.fee = fee
        self.status = status
        self.ratingStar = ratingStar
        self.ratingDesc = ratingDesc
    }
}