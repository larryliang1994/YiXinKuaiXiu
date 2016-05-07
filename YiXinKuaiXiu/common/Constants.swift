//
//  Constants.swift
//  Networking
//
//  Created by 梁浩 on 15/12/12.
//  Copyright © 2015年 LeungHowell. All rights reserved.
//

class Constants {
    static let Types = ["普通维修 ", "打包维修", "预约维修"]
    static let Status = ["待发单", "进行中", "对方请求取消", "申请取消中", "待评价", "待抢单", "已完成"]
    
    struct ControllerID {
        static let PayPopover = "payPopover"
    }
    
    struct UserDefaultKey {
        static let TelephoneNum = "telephoneNum"
        static let VerifyCode = "verifyCode"
        static let Aid = "aid"
        static let Role = "role"
    }
    
    struct Tag {
        static let CustomerDrawerTitle = 1
        static let CustomerDrawerImage = 7
        static let CustomerDrawerBadge = 31
        
        static let CustomerDrawerName = 48
        static let CustomerDrawerTelephone = 49
        
        static let OrderTypeCellImage = 2
        static let OrderTypeCellTitle = 3
        static let OrderTypeCellDesc = 4
        static let OrderPublishConfirmDesc = 5
        static let OrderPublishConfirmAddress = 6
        
        static let CustomerOrderListCellType = 8
        static let CustomerOrderListCellDesc = 9
        static let CustomerOrderListCellMaintenanceType = 10
        static let CustomerOrderListCellStatus = 11
        static let CustomerOrderListCellReminder = 12
        static let CustomerOrderListCellLeftButton = 13
        static let CustomerOrderListCellRightButton = 14
        
        static let PartsMallLeftCellLabel = 15
        static let PartsMallLeftCellSeperator = 16
        static let PartsMallLeftTableView = 17
        static let PartsMallLeftFooterSeperator = 19
        static let PartsMallRightTableView = 18
        static let PartsMallRightTitle = 20
        static let PartsMallRightPrice = 21
        static let PartsMallRightNum = 22
        static let PartsMallRightAdd = 23
        static let PartsMallRightReduce = 24
        
        static let HandymanDrawerBadgeImage = 25
        static let HandymanDrawerBadgeTitle = 26
        static let HandymanDrawerBadge = 27
        static let HandymanDrawerLabelImage = 28
        static let HandymanDrawerLabelTitle = 29
        static let HandymanDrawerLabel = 30
        
        static let OrderGrabCellType = 31
        static let OrderGrabCellDesc = 32
        static let OrderGrabCellMaintenanceType = 33
        static let OrderGrabCellFee = 34
        static let OrderGrabCellFeeImg = 35
        static let OrderGrabCellDistance = 36
        static let OrderGrabCellTime = 37
        static let OrderGrabCellButton = 38
        
        static let HandymanOrderListCellType = 39
        static let HandymanOrderListCellDesc = 40
        static let HandymanOrderListCellMaintanceType = 41
        static let HandymanOrderListCellStatus = 42
        static let HandymanOrderListCellReminder = 43
        static let HandymanOrderListCellLeftButton = 44
        static let HandymanOrderListCellRightButton = 45
        
        static let HandymanChooseMaintenanceTypeCellTitle = 46
        static let HandymanChooseMaintenanceTypeCellCheck = 47
    }
    
    struct SegueID {
        static let PubilshOrderSegue = "pubilshOrderSegue"
        static let EditPriceSegue = "editPriceSegue"
        static let ChooseMaintenanceTyeSegue = "chooseMaintenanceTyeSegue"
        static let ChooseLocationSegue = "chooseLocationSegue"
        static let CustomerDrawerToOrderListSegue = "customerDrawerToOrderListSegue"
        static let CustomerDrawerToPersonalInfoSegue = "customerDrawerToPersonalInfoSegue"
        static let CustomerDrawerToMessageCenterSegue = "customerDrawerToMessageCenterSegue"
        static let CustomerDrawerToMallSegue = "customerDrawerToMallSegue"
        static let ShowPartsMallSegue = "showPartsMallSegue"
        static let ShowCustomerRatingSegue = "showCustomerRatingSegue"
        static let ShowCustomerOrderDetail = "showCustomerOrderDetail"
        static let ShowHandymanInfoSugue = "showHandymanInfoSugue"
        static let ShowCustomerWalletSegue = "showCustomerWalletSegue"
        
        static let ShowOrderPublishConfirmSegue = "showOrderPublishConfirmSegue"
        
        static let HandymanMainSegue = "handymanMainSegue"
        static let CustomerMainSegue = "customerMainSegue"
        
        static let ShowGrabListSegue = "showGrabListSegue"
        static let ShowOrderGrabDetailSegue = "showOrderGrabDetailSegue"
        
        static let HandymanDrawerToOrderListSegue = "handymanDrawerToOrderListSegue"
        static let HandymanDrawerToWalletSegue = "handymanDrawerToWalletSegue"
        static let HandymanDrawerToAuditIDSegue = "handymanDrawerToAuditIDSegue"
        static let HandymanDrawerToMessageCenterSegue = "handymanDrawerToMessageCenterSegue"
        static let HandymanDrawerToProjectBidingSegue = "handymanDrawerToProjectBidingSegue"
        
        static let ShowHandymanOrderDetailSegue = "showHandymanOrderDetailSegue"
        static let ShowHandymanD2DAccountSegue = "showHandymanD2DAccountSegue"
        
        static let ShowHandymanChooseMaintenanceTypeSegue = "showHandymanChooseMaintenanceTypeSegue"
        static let ShowHandymanChooseLocationSegue = "showHandymanChooseLocationSegue"
        
        static let CustomerModifyPersonInfoSefue = "customerModifyPersonInfoSefue"
        static let CustomerChoosePersonInfoLocationSefue = "customerChoosePersonInfoLocationSefue"
        
        static let ShowCustomerD2DAccountSegue = "showCustomerD2DAccountSegue"
        static let ShowCustomerChangePasswordSegue = "showCustomerChangePasswordSegue"
    }
    
    struct Color {
        static let Primary = UIColor(red: 46/255, green: 204/255, blue: 139/255, alpha: 1.0)
        static let Orange = UIColor(red: 253/255, green: 114/255, blue: 0/255, alpha: 1.0)
        static let Gray = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1.0)
        static let Blue = UIColor(red: 38/255, green: 135/255, blue: 253/255, alpha: 1.0)
    }
    
    struct Key {
        static let BaiDuMapAK = "UXx8zEHN9Fad78kxTY4ZQNSw62qjxcZc" 
        static let UMAppKey = "56fc95ec67e58eb5ca0009f4"
        static let BuglyAppKey = "FQxNsqd5EzvoM5ct"
        static let BuglyAppID = "900024596"
    }
    
    struct Role {
        static let Customer = "0"
        static let Handyman = "1"
    }
    
    struct DateFormat {
        static let YMD = "YYYY年MM月dd日"
        static let MDHm = "MM/dd HH:mm"
        static let Full = "YYYY/MM/dd HH:mm"
    }
    
    struct ImageSize {
        static let Portrait = 1000 * 1024
        static let Order = 1000 * 1024
    }
   
    static let Success = 0
    static let Failed = 0
}