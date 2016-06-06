//
//  Config.swift
//  Networking
//
//  Created by 梁浩 on 15/12/12.
//  Copyright © 2015年 LeungHowell. All rights reserved.
//

class Config {
    static var Role: String?
    static var Aid: String?
    static var TelephoneNum: String?
    static var VerifyCode: String?
    static var Name: String?
    static var Location: String?
    static var LocationInfo: CLLocation?
    static var Company: String?
    static var Age: String?
    static var Money: String?
    static var Sex: String?
    static var IDNum: String?
    static var MType: String?
    static var Password: String?
    static var BankName: String?
    static var BankNum: String?
    static var BankOwner: String?
    static var TotalStar: String?
    static var MaintenanceNum: String?
    static var Audited: Int?
    static var PortraitUrl: String?
    static var ContactName: String?
    static var ContactTelephone: String?
    
    static var CurrentLocationInfo: CLLocation?
    
    static var MTypeIDString: String?
    
    static var MTypes: [MaintenanceType]?
    static var MTypeNames: [String]?
    
    static var Fees: [Int] = []
    
    static var Categorys: [Category] = []
    static var Parts: [Part] = []
    
    static var Messages: [Message] = []
    
    static var MessagesNum: Int?
    static var OrderNum: Int?
}