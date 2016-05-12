//
//  D2DAccount.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/5/12.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

class D2DAccount {
    var id: Int?
    var week: String?
    var date: String?
    var fee: String?
    var type: String?
    var status: Int?
    
    init(id: Int, week: String, date: String, fee: String, type: String, status: Int) {
        self.id = id
        self.week = week
        self.date = date
        self.fee = fee
        self.type = type
        self.status = status
    }
}