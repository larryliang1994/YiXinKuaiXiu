//
//  OrderProtocol.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/5/4.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import Foundation

enum PullOrderListType: Int {
    case OnGoing = 0
    case Done
    case All
}

protocol OrderProtocol {
    func publishOrder(order: Order)
    func pullOrderList(requestTime: String, pullType: PullOrderListType)
    func pullGrabOrderList(requestTime: String, distance: Int?)
    func grabOrder(order: Order)
    func cancelOrder(order: Order)
}