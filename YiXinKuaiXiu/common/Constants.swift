//
//  Constants.swift
//  Networking
//
//  Created by 梁浩 on 15/12/12.
//  Copyright © 2015年 LeungHowell. All rights reserved.
//

class Constants {
    struct ControllerID {
        static let PayPopover = "payPopover"
    }
    
    struct UserDefaultKey {
        
    }
    
    struct Tag {
        static let CustomerDrawerTitle = 1
        static let CustomerDrawerImage = 7
        static let CustomerDrawerBadge = 31
        
        static let OrderTypeCellImage = 2
        static let OrderTypeCellTitle = 3
        static let OrderTypeCellDesc = 4
        static let OrderPublishConfirmDesc = 5
        static let OrderPublishConfirmAddress = 6
        
        static let OrderListCellType = 8
        static let OrderListCellDesc = 9
        static let OrderListCellService = 10
        static let OrderListCellStatus = 11
        static let OrderListCellReminder = 12
        static let OrderListCellLeftButton = 13
        static let OrderListCellRightButton = 14
        
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
        
        static let HandymanMainSegue = "handymanMainSegue"
        static let CustomerMainSegue = "customerMainSegue"
        
        static let ShowGrabListSegue = "showGrabListSegue"
    }
    
    struct Color {
        static let Primary = UIColor(red: 46/255, green: 204/255, blue: 139/255, alpha: 1.0)
        static let Orange = UIColor(red: 253/255, green: 114/255, blue: 0/255, alpha: 1.0)
        static let Gray = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1.0)
    }
    
    struct Key {
        static let BaiDuMapAK = "UXx8zEHN9Fad78kxTY4ZQNSw62qjxcZc" 
        static let UMAppKey = "56fc95ec67e58eb5ca0009f4"
        static let BuglyAppKey = "FQxNsqd5EzvoM5ct"
        static let BuglyAppID = "900024596"
    }
    
    struct DateFormat {
        static let MDHm = "MM/dd HH:mm"
        static let Full = "YYYY/MM/dd HH:mm"
    }
    
    struct ImageSize {
        static let Background = 1000 * 1024
        static let Task = 1000 * 1024
        static let Portrait = 1000 * 1024
    }
   
    static let Success = 900001
    static let Failed = 0
}