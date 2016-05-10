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
        self.frame.size = CGSizeMake(240, 170)
        
        backgroundView.layer.cornerRadius = 5
        
        cancelButton.layer.cornerRadius = 3
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = Constants.Color.Gray.CGColor
        
        confirmButton.layer.cornerRadius = 3
        confirmButton.backgroundColor = Constants.Color.Primary
    }
}
