//
//  Order.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/22.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import Foundation
import Photos

class Order {
    var type: String?
    var desc: String?
    var maintenanceType: String?
    var location: String?
    var fee: String?
    var image1: DKAsset?
    var image2: DKAsset?
    
    init(type: String, desc: String, maintenanceType: String, location: String, fee: String, image1: DKAsset?, image2: DKAsset?) {
        self.type = type
        self.desc = desc
        self.maintenanceType = maintenanceType
        self.location = location
        self.fee = fee
        self.image1 = image1
        self.image2 = image2
    }
}