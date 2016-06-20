//
//  ReceiptProtocol.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/6/16.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import Foundation

protocol ReceiptProtocol {
    func getReceiptList()
    func invoice(title: String, fee: String, desc: String)
}