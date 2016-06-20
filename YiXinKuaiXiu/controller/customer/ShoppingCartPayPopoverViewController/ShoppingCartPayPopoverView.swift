//
//  PayPopoverView.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/9.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class ShoppingCartPayPopoverView: UIView, PayDelegate, BCPayDelegate, ChooseCouponDelegate {
    
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
    @IBOutlet var couponLabel: UILabel!
    
    var payWay: Int = 0
    
    var delegate: PopoverPayDelegate?
    
    var bcpayVC: BCPayController?
    
    var viewController: UIViewController?
    
    var date: String?
    var detail: String?
    var fee: String?
    
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
            request.title = "壹心快修"
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
            print(resp.resultMsg + "!!")
            doneThirdPay()
//            PayModel(payDelegate: self).goRecharge(String(Int(Float(fee!)! * 100)))
        } else {
            print(resp.resultMsg + "：" + resp.errDetail)
            delegate?.onPayResult(false, info: "支付取消")
        }
    }
    
    func doneThirdPay() {
        viewController?.pleaseWait()
        
        let couponID = coupon == nil ? "" : coupon?.id!
        
        PayModel(payDelegate: self).goPayParts(date!, detail: detail!, fee: fee!, couponID: couponID!)
    }
    
    func onGoPayPartsResult(result: Bool, info: String) {
        delegate?.onPayResult(result, info: info)
    }
    
    func didChooseCoupon(coupon: Coupon?) {
        self.coupon = coupon
        
        if coupon == nil {
            couponLabel.text = "选择抵用券"
            priceLabel.text = "￥ " + fee!
        } else {
            couponLabel.text = coupon!.fee!.toString() + "元抵用券"
            
            newFee = Float(fee!)! - Float(coupon!.fee!)
            if newFee <= 0 {
                newFee = 0.01
            }
            
            //fee = String(newFee)
            priceLabel.text = "￥ " + String(newFee!)
        }
    }
    
    @IBAction func chooseCoupon(sender: UITapGestureRecognizer) {
        let couponVC = UtilBox.getController(Constants.ControllerID.Coupon) as! CouponViewController
        couponVC.delegate = self
        viewController!.navigationController?.showViewController(couponVC, sender: viewController)
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
