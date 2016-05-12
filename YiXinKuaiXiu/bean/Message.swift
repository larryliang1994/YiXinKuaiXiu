//
//  Message.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/5/12.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

class Message {
    var id: Int?
    var title: String?
    var desc: String?
    var date: String?
    
    init(id: Int, title: String, desc: String, date: String) {
        self.id = id
        self.title = title
        self.desc = desc
        self.date = date
    }
}
