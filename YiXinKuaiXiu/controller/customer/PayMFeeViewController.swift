//
//  PayMFeeViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/5/26.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class PayMFeeViewController: UITableViewController, PopBottomViewDataSource, PopBottomViewDelegate, PopoverPayDelegate, UITextFieldDelegate {
    
    @IBOutlet var textField: UITextField!
    
    var delegate: OrderListChangeDelegate?
    
    var order: Order?

    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
    }
    
    func initView() {
        textField.delegate = self
        
        let item = UIBarButtonItem(title: "提交", style: .Plain, target: self, action: #selector(PayMFeeViewController.submit))
        self.navigationItem.rightBarButtonItem = item
        self.navigationController?.navigationBar.tintColor = UIColor.darkGrayColor()
    }
    
    func submit() {
        if textField.text == nil || textField.text == "" {
            UtilBox.alert(self, message: "请输入维修费")
        } else {
            textField.resignFirstResponder()
            
            order?.mFee = textField.text
            
            let v = PopBottomView(frame: self.view.bounds)
            v.dataSource = self
            v.delegate = self
            v.showInView(self.view)
        }
    }
    
    func hide(){
        for v in self.view.subviews {
            if let vv = v as? PopBottomView{
                vv.hide()
            }
        }
    }
    
    //MARK : - PopBottomViewDataSource
    func viewPop() -> UIView {
        let payPopoverView = UIView.loadFromNibNamed("PayPopoverView") as! PayPopoverView
        payPopoverView.closeButton.addTarget(self, action: #selector(PopBottomView.hide), forControlEvents: UIControlEvents.TouchUpInside)
        payPopoverView.doPayButton.addTarget(self, action: #selector(PopBottomView.hide), forControlEvents: UIControlEvents.TouchUpInside)
        payPopoverView.delegate = self
        payPopoverView.viewController = self
        
        // 付维修费
        payPopoverView.feeLabel.text = "￥" + order!.mFee!
        payPopoverView.fee = order!.mFee
        payPopoverView.type = .MFee
        payPopoverView.date = order!.date!
        
        return payPopoverView
    }
    
    func onPayResult(result: Bool, info: String) {
        self.clearAllNotice()
        if result {
            self.noticeSuccess("支付成功", autoClear: true, autoClearTime: 2)
            delegate?.didChange()
            self.navigationController?.popViewControllerAnimated(true)
        } else {
            UtilBox.alert(self, message: info)
        }
    }
    
    func viewHeight() -> CGFloat {
        return 346
    }
    
    func isEffectView() -> Bool {
        return false
    }
    
    func viewWillAppear() {
        tableView.scrollEnabled = false
    }
    
    func viewWillDisappear() {
        tableView.scrollEnabled = true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if !UtilBox.isNum(string, digital: true) {
            return false
        }
        
        return true
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
}
