//
//  AuditProtocol.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/5/16.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

protocol AuditProtocol {
    func doAudit(name: String, mTypeIDString: String, location: String, locationInfo: CLLocation, IDNum: String, picture: String, contactsName: String, contactNum: String)
}
