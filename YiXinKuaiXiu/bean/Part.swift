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
    var categoryID: Int?
    var categoryIndex: Int?
    var desc: String?
    
    init() {
        
    }
    
    init(name: String, num: Int, price: String, desc: String) {
        self.name = name
        self.num = num
        self.price = Float(price)
        self.desc = desc
        paid = false
    }
    
    init(id: Int, name: String, num: Int, price: Float, desc: String, categoryID: Int) {
        self.id = id
        self.name = name
        self.num = num
        self.price = price
        self.desc = desc
        self.categoryID = categoryID
        paid = false
    }
}