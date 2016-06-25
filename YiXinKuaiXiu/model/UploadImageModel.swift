//
//  UploadImageModel.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/5/5.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import Foundation
import SwiftyJSON

enum UploadImageType {
    case Order
    case ID
}

class UploadImageModel: UploadImageProtocol {
    var uploadImageDelegate: UploadImageDelegate?
    
    init(uploadImageDelegate: UploadImageDelegate) {
        self.uploadImageDelegate = uploadImageDelegate
    }
    
    func uploadOrderImage(image: UIImage, type: UploadImageType) {

        var target = ""
        if type == .ID {
            target = Urls.SendIDImage
        } else if type == .Order {
            target = Urls.SendOrderImage
        }
        
        let uploadurl = Urls.ServerUrl + target + "id=" + Config.Aid! + "&tok=" + Config.VerifyCode!
        
        let request = NSMutableURLRequest(URL:NSURL(string:uploadurl)!)
        request.HTTPMethod="POST"

        let boundary = "-------------------21212222222222222222222"
        let contentType = "multipart/form-data;boundary=" + boundary
        request.addValue(contentType, forHTTPHeaderField:"Content-Type")
        
        let body = NSMutableData()
        body.appendData(NSString(format:"\r\n--\(boundary)\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData(NSString(format:"Content-Disposition:form-data;name=\"dat\";filename=\"dd.jpg\"\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData(NSString(format:"Content-Type:application/octet-stream\r\n\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData(UtilBox.compressImage(image, maxSize: 1000 * 1024))
        body.appendData(NSString(format:"\r\n--\(boundary)").dataUsingEncoding(NSUTF8StringEncoding)!)
        request.HTTPBody = body
        
        let que = NSOperationQueue()
        NSURLConnection.sendAsynchronousRequest(request, queue: que, completionHandler: {
            (response, data, error) ->Void in

            if (error != nil){
                self.uploadImageDelegate?.onUploadOrderImageResult(false, info: "图片上传失败")
            }else{
                let res: String=NSString(data:data!,encoding:NSUTF8StringEncoding)! as String
                
                let responseDic = UtilBox.convertStringToDictionary(res)
                
                if responseDic == nil {
                    self.uploadImageDelegate?.onUploadOrderImageResult(false, info: "图片上传失败")
                    return
                }
                
                let json = JSON(responseDic!)
                
                let ret = json["ret"].intValue
                
                if ret == 0 {
                    self.uploadImageDelegate?.onUploadOrderImageResult(true, info: json["dte"].stringValue)
                } else if ret == 1 {
                    self.uploadImageDelegate?.onUploadOrderImageResult(false, info: "认证失败")
                } else if ret == 2 {
                    self.uploadImageDelegate?.onUploadOrderImageResult(false, info: "图片过大")
                } else if ret == 3 {
                    self.uploadImageDelegate?.onUploadOrderImageResult(false, info: "图片上传失败")
                }
            }
            
        })
        
    }
}

protocol UploadImageDelegate {
    func onUploadOrderImageResult(result: Bool, info: String)
}