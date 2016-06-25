//
//  InvoiceViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/6/21.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class InvoiceViewController: UITableViewController, ReceiptDelegate {

    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var feeTextField: UITextField!
    @IBOutlet var descTextField: UITextField!
    
    var delegate: InvoiceDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func invoice(sender: UIBarButtonItem) {
        if titleTextField.text == nil || titleTextField.text == "" {
            UtilBox.alert(self, message: "请输入发票抬头")
        } else if feeTextField.text == nil || feeTextField.text == "" || UtilBox.isNum(feeTextField.text!, digital: true) {
            UtilBox.alert(self, message: "请输入发票金额")
        } else {
            self.pleaseWait()
            
            if descTextField.text == nil {
                ReceiptModel(receiptDelegate: self).invoice(titleTextField.text!, fee: feeTextField.text!, desc: "")
            } else {
                ReceiptModel(receiptDelegate: self).invoice(titleTextField.text!, fee: feeTextField.text!, desc: descTextField.text!)
            }
        }
    }
    
    func onInvoiceResult(result: Bool, info: String) {
        self.clearAllNotice()
        
        if result {
            self.noticeSuccess("申请成功")
            
            let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
            dispatch_async(dispatch_get_global_queue(qos, 0)) { () -> Void in
                sleep(1)
                dispatch_async(dispatch_get_main_queue(), {
                    self.delegate?.didInvoice()
                    self.navigationController?.popViewControllerAnimated(true)
                })
            }
        } else {
            UtilBox.alert(self, message: info)
        }
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
}

protocol InvoiceDelegate {
    func didInvoice()
}
