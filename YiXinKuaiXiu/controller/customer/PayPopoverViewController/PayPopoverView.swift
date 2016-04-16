//
//  PayPopoverView.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/9.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

extension UIView {
    class func loadFromNibNamed(nibName:String,bundle : NSBundle? = nil) -> UIView? {
        return UINib(nibName: nibName, bundle: bundle).instantiateWithOwner(nil, options: nil)[0] as? UIView
    }
}

class PayPopoverView: UIView {
    //@IBOutlet var doPayButton: UIButton!
    @IBOutlet var doPayButton: UIButton!

    override func awakeFromNib() {
        doPayButton.backgroundColor = Constants.Color.Primary
        doPayButton.layer.cornerRadius = 3
    }
}
