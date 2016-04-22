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
    @IBOutlet var feeLabel: UILabel!
    @IBOutlet var closeButton: UIButton!
    @IBOutlet var aliPayImage: UIImageView!
    @IBOutlet var aliPayTitle: UILabel!
    @IBOutlet var aliPayCheck: UIImageView!
    @IBOutlet var wechatPayImage: UIImageView!
    @IBOutlet var wechatPayTitle: UILabel!
    @IBOutlet var wechatPayCheck: UIImageView!
    
    override func awakeFromNib() {
        doPayButton.backgroundColor = Constants.Color.Primary
        doPayButton.layer.cornerRadius = 3
    }
    
    @IBAction func checkAliPay(recognizer:UITapGestureRecognizer) {
        aliPayCheck.image = UIImage(named: "checked")
        wechatPayCheck.image = nil
    }
    
    @IBAction func checkWechatPay(recognizer:UITapGestureRecognizer) {
        aliPayCheck.image = nil
        wechatPayCheck.image = UIImage(named: "checked")
    }
}
