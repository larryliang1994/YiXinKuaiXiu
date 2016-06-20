//
//  Receipt.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/6/16.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import Foundation

enum ReceiptState: Int {
    case Dealing = 0
    case Passed
    case NotPassed
}

class Receipt {
    var title: String?
    var fee: String?
    var desc: String?
    var state: ReceiptState?
    var reason: String?
    var date: String?
    
    init(title: String, fee: String, desc: String, state: ReceiptState, reason: String, date: String) {
        self.title = title
        self.fee = fee
        self.desc = desc
        self.date = date
        self.state = state
        self.reason = reason
    }
}