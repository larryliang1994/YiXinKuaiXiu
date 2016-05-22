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
        
        requestUrl = requestUrl.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLFragmentAllowedCharacterSet())!
        
        request(.GET, requestUrl)
            .responseString{ response in
                if response.result.isSuccess {
                    callback(result: true, response: response.result.value!)
                } else {
                    callback(result: false, response: "")
                }
        }
    }
    
    static func uploadImage(url: String, parameters: [String: String]!, image: UIImage,
                            callback : (result: Bool, response: String) -> Void) {
        var requestUrl = Urls.ServerUrl + url
        
        for (key, value) in parameters {
            requestUrl += key + "=" + value + "&"
        }
        
        requestUrl = requestUrl.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLFragmentAllowedCharacterSet())!
        
        Alamofire.upload(
            .POST,
            requestUrl,
            multipartFormData: { multipartFormData in
                multipartFormData.appendBodyPart(data: UtilBox.compressImage(image, maxSize: Constants.ImageSize.Order)
                    , name: "dat")
            },
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.progress { (bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) in
                        print("Uploading Avatar \(totalBytesWritten) / \(totalBytesExpectedToWrite)")
                    }
                    upload.responseJSON { response in
                        print(response)
                        if response.result.isSuccess {
                            callback(result: true, response: String(response.result.value!))
                        } else {
                            callback(result: false, response: "")
                        }
                    }
                    
                case .Failure(let encodingError):
                    callback(result: false, response: "")
                }
            }
        );
    }
    
}