//
//  OrderProtocol.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/5/4.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import Foundation

enum PullOrderListType: Int {
    case All = 0
    case OnGoing
    case Done
}

protocol OrderProtocol {
    func publishOrder(order: Order, imgString: String)
    func pullOrderList(requestTime: String, pullType: PullOrderListType)
    func pullGrabOrderList(requestTime: String, fromDistance: Int?, toDistance: Int?)
    func grabOrder(order: Order)
    func cancelOrder(order: Order)
    func cancelOrderConfirm(order: Order, confirm: Bool)
}