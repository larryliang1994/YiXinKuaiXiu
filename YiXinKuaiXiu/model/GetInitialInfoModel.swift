//
//  GetInitialInfoModel.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/5/4.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import Foundation
import SwiftyJSON

class GetInitialInfoModel: GetInitialInfoProtocol {
    var getInitialInfoDelegate: GetInitialInfoDelegate?
    
    init(getInitialInfoDelegate: GetInitialInfoDelegate?) {
        self.getInitialInfoDelegate = getInitialInfoDelegate
    }
    
    func getMaintenanceType() {
        AlamofireUtil.doRequest(Urls.GetMaintenanceType, parameters: [:]) { (result, response) in
            if result {
                let json = JSON(UtilBox.convertStringToDictionary(response)!)
                
                let ret = json["ret"]
                
                if ret != nil {
                    
                    Config.MTypeNames = []
                    Config.MTypes = []
                    for index in 0 ... ret.count - 1 {
                        let mtypeJson = ret[index]
                        
                        let mtype = MaintenanceType(id: mtypeJson["id"].stringValue, name: mtypeJson["nme"].stringValue)
                        
                        Config.MTypeNames?.append(mtypeJson["nme"].stringValue + "维修")
                        Config.MTypes?.append(mtype)
                    }
                    
                }
                
                self.getInitialInfoDelegate?.onGetMaintenanceTypeResult(true, info: "")
            } else {
                self.getInitialInfoDelegate?.onGetMaintenanceTypeResult(false, info: "获取工种失败")
            }
        }
    }
    
    func getAds() {
        
    }
}

protocol GetInitialInfoDelegate {
    func onGetMaintenanceTypeResult(result: Bool, info: String)
}