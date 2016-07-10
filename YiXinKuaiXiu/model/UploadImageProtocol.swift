//
//  UploadImageProtocol.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/5/5.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import Foundation

protocol UploadImageProtocol {
    func uploadImage(image: UIImage, type: UploadImageType)
    func uploadImages(images: [DKAsset])
}