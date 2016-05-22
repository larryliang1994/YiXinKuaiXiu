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

enum PopoverPayType: Int {
    case Fee = 0 // 上门费
    case MFee    // 维修费
    case PackFee // 打包费
}

class PayPopoverView: UIView, PayDelegate, BeeCloudDelegate {
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
    
    var date: String?
    var fee: String?
    var type: PopoverPayType?
    
    var viewController: UIViewController?
    
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
            request.billNo = "12345678"
            request.billTimeOut = 300
            request.viewController = viewController
            
            if payWay == 0 {
                request.channel = .Ali
                request.scheme = "alipayurl"
            } else if payWay == 1 {
                request.channel = .Wx
            }
            
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
        if type == .PackFee { // 付打包费
            PayModel(payDelegate: self).goPay(date!, type: .MPFee, fee: fee!)
        } else if type == .Fee { // 付上门费
            PayModel(payDelegate: self).goPay(date!, type: .Fee, fee: fee!)
        } else if type == .MFee { // 付维修费
            PayModel(payDelegate: self).goPayMFee(date!, fee: fee!)
        }
    }
    
    func onGoPayResult(result: Bool, info: String) {
        delegate?.onPayResult(result, info: info)
    }
    
    func onGoPayMFeeResult(result: Bool, info: String) {
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

protocol PopoverPayDelegate {
    func onPayResult(result: Bool, info: String)
}