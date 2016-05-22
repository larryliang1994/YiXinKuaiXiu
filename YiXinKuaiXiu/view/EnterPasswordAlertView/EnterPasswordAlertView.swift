//
//  EnterPasswordAlertView.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/5/9.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class EnterPasswordAlertView: UIView {

    @IBOutlet var backgroundView: UIView!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var confirmButton: UIButton!
    @IBOutlet var pwdTextField: UITextField!
    
    override func awakeFromNib() {
        self.frame.size = CGSizeMake(240, 175)
        
        backgroundView.layer.cornerRadius = 5
    }
}
