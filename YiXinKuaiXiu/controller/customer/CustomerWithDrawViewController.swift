//
//  CustomerWithDrawViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/5/9.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class CustomerWithDrawViewController: UITableViewController, UITextFieldDelegate, WalletDelegate {
    @IBOutlet var doneButton: UIBarButtonItem!
    @IBOutlet var moneyTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
    }
    
    func initView() {
        doneButton.enabled = false
    }
    
    var alert: OYSimpleAlertController?
    var alertView: EnterPasswordAlertView?
    @IBAction func enterPassword(sender: UIBarButtonItem) {
        moneyTextField.resignFirstResponder()
        
        alert = OYSimpleAlertController()
        alert!.contentOffset = -50
        
        alertView = UIView.loadFromNibNamed("EnterPasswordAlertView") as? EnterPasswordAlertView
        
        alertView!.cancelButton.addTarget(self, action: #selector(CustomerWithDrawViewController.cancel), forControlEvents: UIControlEvents.TouchUpInside)
        
        alertView!.confirmButton.addTarget(self, action: #selector(CustomerWithDrawViewController.doSubmit), forControlEvents: UIControlEvents.TouchUpInside)
        
        alertView?.pwdTextField.becomeFirstResponder()
        
        alert!.initView(alertView!)
        
        presentViewController(alert!, animated: true, completion: nil)
    }
    
    func doSubmit() {
        alertView?.pwdTextField.resignFirstResponder()
        
        WalletModel(walletDelegate: self).doWithDraw(moneyTextField.text!, pwd: (alertView?.pwdTextField.text)!)
        
        self.pleaseWait()
    }
    
    func onWithDrawResult(result: Bool, info: String) {
        self.clearAllNotice()
        
        if result {
            self.noticeSuccess("申请成功", autoClear: true, autoClearTime: 2)
            
            alert?.dismissViewControllerAnimated(true, completion: nil)
            alert = nil
            
            self.navigationController?.popViewControllerAnimated(true)
        } else {
            self.noticeError(info, autoClear: true, autoClearTime: 2)
        }
    }
    
    func cancel() {
        alertView?.pwdTextField.resignFirstResponder()
        alert?.dismissViewControllerAnimated(true, completion: nil)
        alert = nil
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if range.location == 0 && textField.text?.characters.count == 0 {
            doneButton.enabled = true
        } else if range.location == 0 && textField.text?.characters.count == 1 {
            doneButton.enabled = false
        }
        
        return true
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 10 : 20
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? nil : "您有￥20.00余额可供转出"
    }

    func onGetD2DAccountResult(result: Bool, info: String, accountList: [D2DAccount]) {}
}
