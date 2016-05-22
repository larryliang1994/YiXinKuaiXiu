//
//  RechargeViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/5/10.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class RechargeViewController: UITableViewController, UITextFieldDelegate, PopBottomViewDataSource,PopBottomViewDelegate {
    @IBOutlet var feeTextField: UITextField!
    @IBOutlet var doneButton: UIBarButtonItem!
    
    var delegate: WalletChangeDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        doneButton.enabled = false
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if textField.text?.characters.count == 0 && range.location == 0 {
            doneButton.enabled = true
        } else if textField.text?.characters.count == 1 && range.location == 0 {
            doneButton.enabled = false
        }
        
        return true
    }
    
    @IBAction func done(sender: UIBarButtonItem) {
        feeTextField.resignFirstResponder()
        
        let v = PopBottomView(frame: self.view.bounds)
        v.dataSource = self
        v.delegate = self
        v.showInView(self.view)
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
        payPopoverView.doPayButton.addTarget(self, action: #selector(RechargeViewController.goPay), forControlEvents: UIControlEvents.TouchUpInside)
        payPopoverView.balanceImage.hidden = true
        payPopoverView.balanceTitle.hidden = true
        payPopoverView.balanceFee.hidden = true
        payPopoverView.balanceCheck.hidden = true
        
        payPopoverView.feeLabel.text = "￥ " + feeTextField.text!
        return payPopoverView
    }
    
    func goPay() {
        self.noticeSuccess("充值成功", autoClear: true, autoClearTime: 2)
        Config.Money = String(Float(Config.Money!)! + Float(feeTextField.text!)!)
        delegate?.didChange()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func viewWillAppear() {
        tableView.scrollEnabled = false
    }
    
    func viewWillDisappear() {
        tableView.scrollEnabled = true
    }
    
    func viewHeight() -> CGFloat {
        return 295
    }
    
    func isEffectView() -> Bool {
        return false
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
}
