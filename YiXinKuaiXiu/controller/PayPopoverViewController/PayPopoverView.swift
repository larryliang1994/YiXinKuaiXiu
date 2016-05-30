//
//  PayPopoverView.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/9.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

enum PopoverPayType: Int {
    case Fee = 0 // 上门费
    case MFee    // 维修费
    case PackFee // 打包费
    case Recharge // 充值
}

class PayPopoverView: UIView, PayDelegate, BCPayDelegate {
    @IBOutlet var doPayButton: UIButton!
    @IBOutlet var feeLabel: UILabel!
    @IBOutlet var closeButton: UIButton!
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
    
    var date: String?
    var fee: String?
    var type: PopoverPayType?
    
    var viewController: UIViewController?
    
    override func awakeFromNib() {
        balanceFee.text = "￥" + Config.Money!
        
        bcpayVC = BCPayController()
        bcpayVC?.delegate = self
    }
    
    @IBAction func doPay(sender: PrimaryButton) {
        if type == .Recharge {
            payWay = 2
        }
        
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
    
    func doneThirdPay() {
        viewController?.pleaseWait()
        if type == .PackFee { // 付打包费
            PayModel(payDelegate: self).goPay(date!, type: .MPFee, fee: fee!)
        } else if type == .Fee { // 付上门费
            PayModel(payDelegate: self).goPay(date!, type: .Fee, fee: fee!)
        } else if type == .MFee { // 付维修费
            PayModel(payDelegate: self).goPayMFee(date!, fee: fee!)
        } else if type == .Recharge { // 充值
            PayModel(payDelegate: self).goRecharge(fee!)
        }
    }
    
    func onGoRechargeResult(result: Bool, info: String) {
        if type != .Recharge {
            if result {
                doneThirdPay()
            } else {
                delegate?.onPayResult(false, info: info)
            }
        } else {
            delegate?.onPayResult(result, info: info)
        }
    }
    
    func onGoPayResult(result: Bool, info: String) {
        delegate?.onPayResult(result, info: info)
    }
    
    func onGoPayMFeeResult(result: Bool, info: String) {
        delegate?.onPayResult(result, info: info)
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
    
    @IBAction func checkBalance(recognizer:UITapGestureRecognizer) {
        aliPayCheck.image = nil
        wechatPayCheck.image = nil
        balanceCheck.image =  UIImage(named: "checked")
        payWay = 2
    }
}

class BCPayController: UIViewController, BeeCloudDelegate {
    var delegate: BCPayDelegate?
    
    func onBeeCloudResp(resp: BCBaseResp!) {
        delegate?.onBCPayResult(resp)
    }
}

protocol BCPayDelegate {
    func onBCPayResult(resp: BCBaseResp!)
}

protocol PopoverPayDelegate {
    func onPayResult(result: Bool, info: String)
}