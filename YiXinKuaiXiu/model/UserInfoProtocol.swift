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
}