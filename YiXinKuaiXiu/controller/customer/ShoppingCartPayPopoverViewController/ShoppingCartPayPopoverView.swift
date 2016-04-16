//
//  PayPopoverView.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/9.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class ShoppingCartPayPopoverView: UIView {
    
    @IBOutlet var doPayButton: UIButton!
    
    override func awakeFromNib() {
        doPayButton.backgroundColor = Constants.Color.Primary
        doPayButton.layer.cornerRadius = 3
    }
}
