//
//  GetPartsInfoModel.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/5/12.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import Foundation
import SwiftyJSON

class GetPartsInfoModel: GetPartsInfoProtocol {
    var getPartsInfoDelegate: GetPartsInfoDelegate?
    
    init(getPartsInfoDelegate: GetPartsInfoDelegate) {
        self.getPartsInfoDelegate = getPartsInfoDelegate
    }
    
    func doGetCategoryInfo() {
        AlamofireUtil.doRequest(Urls.GetCategoryList, parameters: [:]) { (result, response) in
            if result {
                let responseDic = UtilBox.convertStringToDictionary(response)
                
                if responseDic == nil {
                    self.getPartsInfoDelegate?.onGetCategoryInfoResult(false, info: "获取商品类别失败")
                    return
                }
                
                let json = JSON(responseDic!)
                
                let ret = json["ret"]
                if ret != nil && ret.count != 0 {
                
                    Config.Categorys = []
                    for index in 0 ... ret.count - 1 {
                        let category = Category(id: ret[index]["id"].intValue, name: ret[index]["nme"].stringValue, partIndex: 0)

                        Config.Categorys.append(category)
                    }
                }
                
                self.getPartsInfoDelegate?.onGetCategoryInfoResult(true, info: "")
            } else {
                self.getPartsInfoDelegate?.onGetCategoryInfoResult(false, info: "获取商品类别失败")
            }
        }
    }
    
    func doGetPartsInfo() {
        AlamofireUtil.doRequest(Urls.GetPartsList, parameters: ["pid": "0"]) { (result, response) in
            if result {
                let responseDic = UtilBox.convertStringToDictionary(response)
                
                if responseDic == nil {
                    self.getPartsInfoDelegate?.onGetPartsInfoResult(false, info: "获取商品信息失败")
                    return
                }
                
                let json = JSON(responseDic!)
                
                let ret = json["ret"]
                if ret != nil && ret.count != 0 {
                    
                    Config.Parts = []
                    for index in 0 ... ret.count - 1 {
                        let part = Part(id: ret[index]["odr"].intValue, name: ret[index]["nme"].stringValue, num: 0, price: ret[index]["prs"].floatValue, categoryID: ret[index]["pid"].intValue)
                        
                        Config.Parts.append(part)
                    }
                }
                
                self.getPartsInfoDelegate?.onGetPartsInfoResult(true, info: "")
            } else {
                self.getPartsInfoDelegate?.onGetPartsInfoResult(false, info: "获取商品信息失败")
            }
        }
    }
}

protocol GetPartsInfoDelegate {
    func onGetCategoryInfoResult(result: Bool, info: String)
    func onGetPartsInfoResult(result: Bool, info: String)
}