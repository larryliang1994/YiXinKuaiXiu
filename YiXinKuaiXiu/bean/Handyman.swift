//
//  Handyman.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/5/20.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import Foundation

class Handyman {
    var name: String?
    var latitude: String?
    var longitude: String?
    
    init(name: String, latitude: String, longitude: String) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
}