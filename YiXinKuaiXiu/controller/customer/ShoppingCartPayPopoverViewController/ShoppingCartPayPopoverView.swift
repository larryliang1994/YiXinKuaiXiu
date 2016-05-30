//
//  PayPopoverView.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/9.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class ShoppingCartPayPopoverView: UIView, PayDelegate, BCPayDelegate {
    
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
    
    var bcpayVC: BCPayController?
    
    var viewController: UIViewController?
    
    var date: String?
    var detail: String?
    var fee: String?
    
    override func awakeFromNib() {
        balanceFee.text = "￥" + Config.Money!
        
        bcpayVC = BCPayController()
        bcpayVC?.delegate = self
    }
    
    @IBAction func doPay(sender: PrimaryButton) {
        if payWay == 2 {
            doneThirdPay()
        } else {
            BeeCloud.setBeeCloudDelegate(bcpayVC)
            
            let request = BCPayReq()
            request.title = "壹心快修"
            request.totalFee = String(Int(Float(fee!)! * 100))
            request.billNo = Int(NSDate().timeIntervalSince1970 * 1000).toString()
            request.billTimeOut = 300
            request.viewController = viewController
            
            if payWay == 0 {
                request.channel = .AliApp
                request.scheme = "yxkxalipayurl"
            } else if payWay == 1 {
                request.channel = .WxApp
            }
            
            BeeCloud.sendBCReq(request)
        }
    }
    
    func onBCPayResult(resp: BCBaseResp!) {
        if resp.resultCode == 0 {
            print(resp.resultMsg + "!!")
            PayModel(payDelegate: self).goRecharge(String(Int(Float(fee!)! * 100)))
        } else {
            print(resp.resultMsg + "：" + resp.errDetail)
            delegate?.onPayResult(false, info: "支付取消")
        }
    }
    
    func onGoRechargeResult(result: Bool, info: String) {
        if result {
            doneThirdPay()
        } else {
            delegate?.onPayResult(false, info: info)
        }
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
