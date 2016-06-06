//
//  RatingModel.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/5/13.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import Foundation
import SwiftyJSON

class RatingModel: RatingProtocol {
    var ratingDelegate: RatingDelegate?
    
    init(ratingDelegate: RatingDelegate) {
        self.ratingDelegate = ratingDelegate
    }
    
    func doRating(date: String, star: Int, desc: String) {
        AlamofireUtil.doRequest(Urls.Rating, parameters: ["id": Config.Aid!, "tok": Config.VerifyCode!, "dte": date, "fen": star.toString(), "fem": desc]) { (result, response) in
            if result {
                let responseDic = UtilBox.convertStringToDictionary(response)
                
                if responseDic == nil {
                    UtilBox.reportBug(response)
                    self.ratingDelegate?.onRatingResult(false, info: "评价失败")
                    return
                }
                
                let json = JSON(responseDic!)
                
                let ret = json["ret"].intValue
                
                if ret == 0 {
                    self.ratingDelegate?.onRatingResult(true, info: "")
                } else if ret == 1 {
                    self.ratingDelegate?.onRatingResult(false, info: "认证失败")
                } else if ret == 2 {
                    self.ratingDelegate?.onRatingResult(false, info: "没有该订单")
                } else if ret == 3 {
                    self.ratingDelegate?.onRatingResult(false, info: "订单所处的状态无法修改")
                } else if ret == 4 {
                    self.ratingDelegate?.onRatingResult(false, info: "失败")
                }
                
            } else {
                self.ratingDelegate?.onRatingResult(false, info: "评价失败")
            }
        }
    }
}

protocol RatingDelegate {
    func onRatingResult(result: Bool, info: String)
}