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
    @IBOutlet var descLabel: UILabel!
    @IBOutlet var closeButton: UIButton!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var aliPayImage: UIImageView!
    @IBOutlet var aliPayTitle: UILabel!
    @IBOutlet var aliPayCheck: UIImageView!
    @IBOutlet var wechatPayImage: UIImageView!
    @IBOutlet var wechatPayTitle: UILabel!
    @IBOutlet var wechatPayCheck: UIImageView!
    @IBOutlet var balanceImage: UIImageView!
    @IBOutlet var balanceTitle: UILabel!
    @IBOutlet var balanceFee: UILabel!
    @IBOutlet var balanceCheck: UIImageView!
    
    override func awakeFromNib() {
        doPayButton.backgroundColor = Constants.Color.Primary
        doPayButton.layer.cornerRadius = 3
    }
    
    @IBAction func checkAliPay(recognizer:UITapGestureRecognizer) {
        aliPayCheck.image = UIImage(named: "checked")
        wechatPayCheck.image = nil
        balanceCheck.image = nil
    }
    
    @IBAction func checkWechatPay(recognizer:UITapGestureRecognizer) {
        aliPayCheck.image = nil
        wechatPayCheck.image = UIImage(named: "checked")
        balanceCheck.image = nil
    }
    
    @IBAction func checkBalance(sender: UITapGestureRecognizer) {
        aliPayCheck.image = nil
        wechatPayCheck.image = nil
        balanceCheck.image = UIImage(named: "checked")
    }
    
}
