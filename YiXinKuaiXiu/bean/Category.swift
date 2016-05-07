//
//  Category.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/5/7.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import Foundation

class Category {
    var id: Int?
    var name: String?
    var partIndex: Int?
    
    init(id: Int, name: String, partIndex: Int) {
        self.id = id
        self.name = name
        self.partIndex = partIndex
    }
}