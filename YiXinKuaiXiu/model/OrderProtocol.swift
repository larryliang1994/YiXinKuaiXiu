//
//  OrderProtocol.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/5/4.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import Foundation

enum PullOrderListType {
    case Refresh
    case LoadMore
}

protocol OrderProtocol {
    func publishOrder(order: Order)
    func pullOrderList(requestTime: String, type: PullOrderListType)
}