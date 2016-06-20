//
//  Urls.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/22.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import Foundation

class Urls {
    static let ServerUrl = "https://www.yixinkuaixiu.com/svr/"
    static let PortraitServer = "https://www.yixinkuaixiu.com/uld/2/"
    static let OrderImgServer = "https://www.yixinkuaixiu.com/uld/3/"
    static let AdServer = "https://www.yixinkuaixiu.com/uld/0/"
    
    static let Recharge = "https://www.yixinkuaixiu.com/pay/alipay/notify_url.php?"
    
    static let Login = "100.php?"
    static let GetVerifyCode = "11.php?"
    static let ModifyUserInfo = "12.php?"
    static let GetUserInfo = "13.php?"
    static let UpdateLocationInfo = "14.php?"
    static let GetHandymanInfo = "15.php?"
    static let ChangePassword = "16.php?"
    static let MultiModify = "17.php?"
    static let GetMaintenanceType = "21.php?"
    static let GetFeeList = "22.php?"
    static let GetCategoryList = "23.php?"
    static let GetPartsList = "24.php?"
    static let GetMessage = "25.php?"
    static let GetAds = "26.php?"
    static let GetD2DAccount = "27.php?"
    static let GetBlacklist = "28.php?"
    static let GetReceiptList = "29.php?"
    static let Invoice = "30.php?"
    static let WithDraw = "31.php?"
    static let GetBillNumber = "32.php?"
    static let SetMessageRead = "35.php?"
    static let GetMessageNum = "36.php?"
    static let GetOrderNum = "37.php?"
    static let GetCouponList = "38.php?"
    static let SendIDImage = "42.php?"
    static let SendOrderImage = "43.php?"
    static let GetNearbyHandyman = "50.php?"
    static let PullCustomerOrderList = "51.php?"
    static let PublishOrder = "52.php?"
    static let GoPay = "53.php?"
    static let CancelOrder = "54.php?"
    static let PayMFee = "55.php?"
    static let PayParts = "56.php?"
    static let Rating = "57.php?"
    static let GetNearbyCustomer = "60.php?"
    static let PullHandymanOrderList = "61.php?"
    static let PullGrabOrderList = "62.php?"
    static let GrabOrder = "63.php?"
    static let CancelOrderConfirm = "64.php?" // cnt应该在这里返回
}