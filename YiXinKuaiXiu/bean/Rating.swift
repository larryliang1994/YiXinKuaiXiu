//
//  Rating.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/5/20.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import Foundation

class Rating {
    var date: String?
    var star: Int?
    var desc: String?
    
    init(date: String, star: Int, desc: String) {
        self.date = date
        self.star = star
        self.desc = desc
    }
}