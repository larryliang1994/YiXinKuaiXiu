//
//  AlertView.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/28.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class AlertView: UIView {
    @IBOutlet var backgroundView: UIView!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var confirmButton: UIButton!

    override func awakeFromNib() {
        self.frame.size = CGSizeMake(230, 105)
        
        backgroundView.layer.cornerRadius = 5
        
    }
}
