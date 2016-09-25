//
//  ProtocolViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/7/5.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class ProtocolViewController: UIViewController, UITextViewDelegate {
    @IBOutlet var textView: UITextView!
    
    override func viewWillAppear(animated: Bool) {
        textView.becomeFirstResponder()
        textView.selectedRange = NSMakeRange(0, 0)
    }
    
    override func viewDidAppear(animated: Bool) {
        textView.resignFirstResponder()
        textView.editable = false
    }

}
