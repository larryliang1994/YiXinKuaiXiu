//
//  WalletProtocol.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/5/12.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

protocol WalletProtocol {
    func doWithDraw(money: String, pwd: String)
    func doGetD2DAccount()
}
