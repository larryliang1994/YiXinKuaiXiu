//
//  AlamofireUtil.swift
//  Networking
//
//  Created by 梁浩 on 15/12/12.
//  Copyright © 2015年 LeungHowell. All rights reserved.
//

import Foundation
import Alamofire

class AlamofireUtil {
    static func doRequest(url: String, parameters: [String: String]!,
        callback : (result: Bool, response: String) -> Void) {
        
        var requestUrl = Urls.ServerUrl + url
        
        for (key, value) in parameters {
             requestUrl += key + "=" + value + "&"
        }

        request(.GET, requestUrl)
            .responseString{ response in
                if response.result.isSuccess {
                    callback(result: true, response: response.result.value!)
                } else {
                    callback(result: false, response: "")
                }
        }
    }
    
}