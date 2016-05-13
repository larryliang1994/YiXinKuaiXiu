//
//  Urls.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/22.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import Foundation

class Urls {
    static let ServerUrl = "http://yxkx.carvedge.com/svr/"
    
    static let Login = "100.php?"
    static let GetVerifyCode = "11.php?"
    static let ModifyUserInfo = "12.php?"
    static let GetUserInfo = "13.php?"
    static let UpdateLocationInfo = "14.php?"
    static let GetMaintenanceType = "21.php?"
    static let GetFeeList = "22.php?"
    static let GetCategoryList = "23.php?"
    static let GetPartsList = "24.php?"
    static let GetMessage = "25.php?" // 返回为空，badge不知道怎么显示
    static let GetAds = "26.php?" // 未完成
    static let GetD2DAccount = "27.php?"
    static let WithDraw = "31.php?"
    static let SendOrderImage = "43.php?"
    static let PullOrderList = "51.php?"
    static let PublishOrder = "52.php?"
    static let GoPay = "53.php?"
    static let CancelOrder = "54.php?" // 未完成
    static let PayMFee = "55.php?" // 未完成
    static let PayParts = "56.php?" // 未完成
    static let Rating = "57.php?"
}