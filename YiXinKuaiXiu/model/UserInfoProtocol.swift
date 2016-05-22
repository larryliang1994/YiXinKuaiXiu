//
//  UserInfoProtocol.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/26.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

protocol UserInfoProtocol {
    func doGetUserInfo()
    func doModifyUserInfo(parameters: [String: String])
    func doUpdateLocationInfo(parameters: [String])
    func doGetHandymanInfo(id: String)
    func doBindBankCard(name: String, bank: String, num: String)
    func doChangePassword(old: String, new: String)
}