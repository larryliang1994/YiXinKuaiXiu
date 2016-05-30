//
//  GetNearByModel.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/5/20.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import Foundation
import SwiftyJSON

class GetNearbyModel: GetNearbyProtocol {
    var getNearbyDelegate: GetNearbyDelegate?
    
    init(getNearbyDelegate: GetNearbyDelegate) {
        self.getNearbyDelegate = getNearbyDelegate
    }
    
    func doGetNearby(latitude: String, longitude: String, distance: Int) {
        let paramters = ["id": Config.Aid!, "tok": Config.VerifyCode!, "lat": latitude, "lot": longitude, "dis": distance.toString()]
        
        AlamofireUtil.doRequest(Urls.GetNearbyHandyman, parameters: paramters) { (result, response) in
            if result {
                print(response)
                let responseDic = UtilBox.convertStringToDictionary(response)
                
                if responseDic == nil {
                    self.getNearbyDelegate?.onGetNearbyResult(false, info: "获取附近师傅坐标失败", personList: [])
                    return
                }
                
                let json = JSON(responseDic!)
                
                let ret = json["ret"]
                
                var personList: [Person] = []
                
                if ret != nil && ret.count != 0 {
                    for var index in 0 ... ret.count-1 {
                        let person = Person(name: ret[index]["nme"].stringValue, latitude: ret[index]["lat"].stringValue, longitude: ret[index]["lot"].stringValue)
                        
                        personList.append(person)
                    }
                }
                
                self.getNearbyDelegate?.onGetNearbyResult(true, info: "", personList: personList)
            } else {
                self.getNearbyDelegate?.onGetNearbyResult(false, info: "获取附近用户坐标失败", personList: [])
            }
        }
    }
}

protocol GetNearbyDelegate {
    func onGetNearbyResult(result: Bool, info: String, personList: [Person])
}