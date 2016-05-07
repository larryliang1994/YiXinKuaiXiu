//
//  UploadImageModel.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/5/5.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import Foundation
import SwiftyJSON

class UploadImageModel: UploadImageProtocol {
    var uploadImageDelegate: UploadImageDelegate?
    
    init(uploadImageDelegate: UploadImageDelegate) {
        self.uploadImageDelegate = uploadImageDelegate
    }
    
    func uploadOrderImage(image: UIImage) {
        let parameters = ["id": Config.Aid!, "tok": Config.VerifyCode!]
        AlamofireUtil.uploadImage(Urls.SendOrderImage, parameters: parameters, image: image) { (result, response) in
            if result {
//                let source = UtilBox.convertStringToDictionary(response)
//                var json = JSON(source == nil ? response : source!)
//                print(json.description)
//                json = JSON(UtilBox.convertStringToDictionary(json.description)!)
//                let ret = json["ret"]
//                
//                print(ret)
                
                self.uploadImageDelegate?.onUploadOrderImageResult(true, info: "")
            } else {
                self.uploadImageDelegate?.onUploadOrderImageResult(false, info: "图片上传失败")
            }
        }
    }
}

protocol UploadImageDelegate {
    func onUploadOrderImageResult(result: Bool, info: String)
}