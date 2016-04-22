//
//  loginProtocol.swift
//  TaskMoment
//
//  Created by 梁浩 on 15/12/14.
//  Copyright © 2015年 LeungHowell. All rights reserved.
//

protocol LoginProtocol {
    func doGetVerifyCode(type: String, telephoneNum: String)
    func doLogin(telephoneNum: String, verifyCode: String)
}
