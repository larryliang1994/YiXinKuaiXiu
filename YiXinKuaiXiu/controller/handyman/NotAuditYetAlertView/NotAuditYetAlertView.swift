//
//  NotAuditYetAlertView.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/19.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class NotAuditYetAlertView: UIView {
    
    @IBOutlet var backgroundView: UIView!
    @IBOutlet var msgLabel: UILabel!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var doAuditButton: UIButton!
    
    override func awakeFromNib() {
        
        self.frame.size = CGSizeMake(230, 105)
        
        backgroundView.layer.cornerRadius = 5
        
        cancelButton.layer.cornerRadius = 3
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = Constants.Color.Gray.CGColor
        
        doAuditButton.layer.cornerRadius = 3
        doAuditButton.backgroundColor = Constants.Color.Primary
    }
    
    
}
