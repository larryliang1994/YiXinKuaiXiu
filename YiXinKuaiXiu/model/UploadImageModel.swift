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

class UploadImageModel: UploadImageProtocol, UploadImageDelegate {
    var uploadImageDelegate: UploadImageDelegate?
    
    var uploadedNum = 0
    var imageUrls = ""
    
    init(uploadImageDelegate: UploadImageDelegate) {
        self.uploadImageDelegate = uploadImageDelegate
    }
    
    func uploadImages(images: [DKAsset]) {
        uploadedNum = 0
        imageUrls = ""
        
        var imgs: [UIImage] = []
        
        for var i in images {
            imgs.append(UtilBox.getAssetThumbnail(i.originalAsset!))
        }
        
        doUploadImages(imgs)
    }
    
    func doUploadImages(images: [UIImage]) {
        let que = NSOperationQueue()
        NSURLConnection.sendAsynchronousRequest(generateRequest(images[uploadedNum], type: .Order), queue: que, completionHandler: {
            (response, data, error) -> Void in
            
            if (error != nil){
                self.uploadImageDelegate?.onUploadImageResult!(false, info: "图片上传失败")
            }else{
                let res: String = NSString(data:data!,encoding:NSUTF8StringEncoding)! as String
                
                let responseDic = UtilBox.convertStringToDictionary(res)
                
                if responseDic == nil {
                    self.uploadImageDelegate?.onUploadImagesResult!(false, info: "图片上传失败")
                    return
                }
                
                let json = JSON(responseDic!)
                
                let ret = json["ret"].intValue
                
                if ret == 0 {
                    // 记录已上传的图片的文件名
                    self.imageUrls += self.uploadedNum == 0 ? json["dte"].stringValue : "," + json["dte"].stringValue
                    
                    // 已上传的图片数加一
                    self.uploadedNum += 1
                    
                    if self.uploadedNum < images.count {
                        // 接着上传下一张图片
                        self.doUploadImages(images)
                    } else {
                        self.uploadImageDelegate?.onUploadImagesResult!(true, info: self.imageUrls)
                    }
                    
                } else {
                    self.uploadImageDelegate?.onUploadImagesResult!(false, info: "图片上传失败")
                }
            }
        })
    }
    
    func uploadImage(image: UIImage, type: UploadImageType) {

        let que = NSOperationQueue()
        NSURLConnection.sendAsynchronousRequest(generateRequest(image, type: type), queue: que, completionHandler: {
            (response, data, error) ->Void in

            if (error != nil){
                self.uploadImageDelegate?.onUploadImageResult!(false, info: "图片上传失败")
            }else{
                let res: String=NSString(data:data!,encoding:NSUTF8StringEncoding)! as String
                
                let responseDic = UtilBox.convertStringToDictionary(res)
                
                if responseDic == nil {
                    self.uploadImageDelegate?.onUploadImageResult!(false, info: "图片上传失败")
                    return
                }
                
                let json = JSON(responseDic!)
                
                let ret = json["ret"].intValue
                
                if ret == 0 {
                    self.uploadImageDelegate?.onUploadImageResult!(true, info: json["dte"].stringValue)
                } else if ret == 1 {
                    self.uploadImageDelegate?.onUploadImageResult!(false, info: "认证失败")
                } else if ret == 2 {
                    self.uploadImageDelegate?.onUploadImageResult!(false, info: "图片过大")
                } else if ret == 3 {
                    self.uploadImageDelegate?.onUploadImageResult!(false, info: "图片上传失败")
                }
            }
        })
    }
    
    func generateRequest(image: UIImage, type: UploadImageType) -> NSMutableURLRequest {
        var target = ""
        if type == .ID {
            target = Urls.SendIDImage
        } else if type == .Order {
            target = Urls.SendOrderImage
        }
        
        let uploadurl = Urls.ServerUrl + target + "id=" + Config.Aid! + "&tok=" + Config.VerifyCode!
        
        let request = NSMutableURLRequest(URL:NSURL(string:uploadurl)!)
        request.HTTPMethod = "POST"
        
        let boundary = "-------------------21212222222222222222222"
        let contentType = "multipart/form-data;boundary=" + boundary
        request.addValue(contentType, forHTTPHeaderField:"Content-Type")
        
        let body = NSMutableData()
        body.appendData(NSString(format:"\r\n--\(boundary)\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData(NSString(format:"Content-Disposition:form-data;name=\"dat\";filename=\"dd.jpg\"\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData(NSString(format:"Content-Type:application/octet-stream\r\n\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData(UtilBox.compressImage(image, maxSize: 700 * 1024))
        body.appendData(NSString(format:"\r\n--\(boundary)").dataUsingEncoding(NSUTF8StringEncoding)!)
        request.HTTPBody = body
        
        return request
    }
}

@objc protocol UploadImageDelegate {
    optional func onUploadImagesResult(result: Bool, info: String)
    optional func onUploadImageResult(result: Bool, info: String)
}