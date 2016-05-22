//
//  PayPopoverView.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/9.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class ShoppingCartPayPopoverView: UIView, PayDelegate, BeeCloudDelegate {
    
    @IBOutlet var doPayButton: PrimaryButton!
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
    
    var payWay: Int = 0
    
    var delegate: PopoverPayDelegate?
    
    var viewController: UIViewController?
    
    var date: String?
    var detail: String?
    var fee: String?
    
    override func awakeFromNib() {
        balanceFee.text = "￥" + Config.Money!
    }
    
    @IBAction func doPay(sender: PrimaryButton) {
        if payWay == 2 {
            doneThirdPay()
        } else {
            BeeCloud.setBeeCloudDelegate(self)
            
            let request = BCPayReq()
            request.title = "这是标题"
            request.totalFee = Int(Float(fee!)! * 100).toString()
            request.billNo = date
            request.viewController = viewController
            
            if payWay == 0 {
                request.channel = .Ali
                request.scheme = "alipayurl"
            } else if payWay == 1 {
                request.channel = .Wx
            }
            
            print("send" + Int(Float(fee!)! * 100).toString())
            
            BeeCloud.sendBCReq(request)
        }
    }
    
    func onBeeCloudResp(resp: BCBaseResp!) {
        if resp.resultCode == 0 {
            print(resp.resultMsg + "!!")
        } else {
            print(resp.resultMsg + "：" + resp.errDetail)
        }
        
        doneThirdPay()
    }
    
    func doneThirdPay() {
        viewController?.pleaseWait()
        PayModel(payDelegate: self).goPayParts(date!, detail: detail!, fee: fee!)
    }
    
    func onGoPayPartsResult(result: Bool, info: String) {
        delegate?.onPayResult(result, info: info)
    }
    
    @IBAction func checkAliPay(recognizer:UITapGestureRecognizer) {
        aliPayCheck.image = UIImage(named: "checked")
        wechatPayCheck.image = nil
        balanceCheck.image = nil
        payWay = 0
    }
    
    @IBAction func checkWechatPay(recognizer:UITapGestureRecognizer) {
        aliPayCheck.image = nil
        wechatPayCheck.image = UIImage(named: "checked")
        balanceCheck.image = nil
        payWay = 1
    }
    
    @IBAction func checkBalance(sender: UITapGestureRecognizer) {
        aliPayCheck.image = nil
        wechatPayCheck.image = nil
        balanceCheck.image = UIImage(named: "checked")
        payWay = 2
    }
    
    
}
