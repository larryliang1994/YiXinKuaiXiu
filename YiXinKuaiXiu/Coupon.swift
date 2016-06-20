//
//  Coupon.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/6/14.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import Foundation

class Coupon {
    var id: String?
    var fee: Int?
    var desc: String?
    var used: Bool?
    var date: String?
    
    init(id: String, fee: Int, desc: String, used: Bool, date: String) {
        self.id = id
        self.fee = fee
        self.desc = desc
        self.used = used
        self.date = date
    }
}