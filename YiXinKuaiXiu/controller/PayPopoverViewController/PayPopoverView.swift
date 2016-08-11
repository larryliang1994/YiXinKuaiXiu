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

class PayPopoverView: UIView, PayDelegate, BCPayDelegate, ChooseCouponDelegate {
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
    @IBOutlet var couponLabel: UILabel!
    
    var payWay: Int = 0
    
    var delegate: PopoverPayDelegate?
    
    var bcpayVC: BCPayController?
    
    var date: String?
    var fee: String?
    var type: PopoverPayType?
    
    var viewController: UIViewController?
    
    var coupon: Coupon?
    var newFee: Float?
    
    override func awakeFromNib() {
        balanceFee.text = "￥" + Config.Money!
        
        bcpayVC = BCPayController()
        bcpayVC?.delegate = self
    }
    
    @IBAction func doPay(sender: PrimaryButton) {
        if payWay == 2 {
            doneThirdPay()
        } else {
            viewController?.pleaseWait()
            
            if self.coupon != nil {
                PayModel(payDelegate: self).getBillNumber(String(newFee!))
            } else {
                PayModel(payDelegate: self).getBillNumber(fee!)
            }
            
            //PayModel(payDelegate: self).getBillNumber("0.01")
            //PayModel(payDelegate: self).getBillNumber(fee!)
        }
    }
    
    func onGetBillNumberResult(result: Bool, info: String) {
        let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
        dispatch_async(dispatch_get_global_queue(qos, 0)) { () -> Void in
            sleep(2)
            dispatch_async(dispatch_get_main_queue(), {
                self.viewController?.clearAllNotice()
            })
        }
        
        if result {
            let currentFee = coupon == nil ? fee! : String(newFee!)
            
            BeeCloud.setBeeCloudDelegate(bcpayVC)
            
            let request = BCPayReq()
            request.title = "谊心快修"
            request.totalFee = String(Int(Float(currentFee)! * 100))
            //request.totalFee = "1"
            request.billNo = info
            request.billTimeOut = 300
            request.viewController = viewController
            
            if payWay == 0 {
                request.channel = .AliApp
                request.scheme = "yxkxalipayurl"
            } else if payWay == 1 {
                request.channel = .WxApp
            }
            
            BeeCloud.sendBCReq(request)
        } else {
            delegate?.onPayResult(false, info: info)
        }
    }
    
    func onBCPayResult(resp: BCBaseResp!) {
        viewController?.clearAllNotice()
        
        if resp.resultCode == 0 {
            doneThirdPay()
        } else if resp.resultCode == -2 ||  resp.errDetail != nil || resp.errDetail == "" {
            delegate?.onPayResult(false, info: "支付取消")
        } else {
            delegate?.onPayResult(false, info: resp.errDetail)
            UtilBox.reportBug(resp.resultMsg + "：" + resp.errDetail)
        }
    }
    
    func doneThirdPay() {
        viewController?.pleaseWait()
        
        //let currentFee = coupon == nil ? fee! : String(newFee)
        let currentFee = fee!
        let couponID = coupon == nil ? "" : coupon?.id!
        
        if type == .PackFee { // 付打包费
            PayModel(payDelegate: self).goPay(date!, type: .MPFee, fee: currentFee, couponID: couponID!)
        } else if type == .Fee { // 付上门费
            PayModel(payDelegate: self).goPay(date!, type: .Fee, fee: currentFee, couponID: couponID!)
        } else if type == .MFee { // 付维修费
            PayModel(payDelegate: self).goPayMFee(date!, fee: fee!, couponID: couponID!)
        } else if type == .Recharge { // 充值
            delegate?.onPayResult(true, info: "充值成功")
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
    
    @IBAction func chooseCoupon(sender: UITapGestureRecognizer) {
        if type == .Recharge {
            return
        }
        
        let couponVC = UtilBox.getController(Constants.ControllerID.Coupon) as! CouponViewController
        couponVC.delegate = self
        viewController!.navigationController?.showViewController(couponVC, sender: viewController)
    }
    
    func didChooseCoupon(coupon: Coupon?) {
        self.coupon = coupon
        
        if coupon == nil {
            couponLabel.text = "选择抵用券"
            feeLabel.text = "￥ " + fee!
        } else {
            couponLabel.text = coupon!.fee!.toString() + "元抵用券"
        
            newFee = Float(fee!)! - Float(coupon!.fee!)
            if newFee <= 0 {
                newFee = 0.01
            }
        
            //fee = String(newFee)
            feeLabel.text = "￥ " + String(newFee!)
        }
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