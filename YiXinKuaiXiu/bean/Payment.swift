//
//  Payment.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/26.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import Foundation

class Payment {
    var name: String?
    var price: Float?
    var paid: Bool
    
    init(name: String, price: Float, paid: Bool) {
        self.name = name
        self.price = price
        self.paid = paid
    }
}