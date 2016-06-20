//
//  PayProtocol.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/5/13.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

protocol PayProtocol {
    func goPay(date: String, type: PayType, fee: String, couponID: String)
    func goPayParts(date: String, detail: String, fee: String, couponID: String)
    func goPayMFee(date: String, fee: String, couponID: String)
//    func goRecharge(fee: String)
    func getBillNumber(fee: String)
}