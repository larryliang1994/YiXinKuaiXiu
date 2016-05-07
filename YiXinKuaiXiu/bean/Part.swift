//
//  Part.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/26.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import Foundation

class Part {
    var id: Int?
    var name: String?
    var num: Int?
    var price: Float?
    var paid = false
    var categoryIndex: Int?
    
    init() {
        
    }
    
    init(name: String, num: Int, price: String) {
        self.name = name
        self.num = num
        self.price = Float(price)
        paid = false
    }
    
    init(id: Int, name: String, num: Int, price: Float, categoryIndex: Int) {
        self.id = id
        self.name = name
        self.num = num
        self.price = price
        self.categoryIndex = categoryIndex
        paid = false
    }
}