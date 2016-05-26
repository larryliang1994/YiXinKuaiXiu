//
//  CheckFeeViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/8.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class CheckFeeViewController: UITableViewController, UITextFieldDelegate {

    var delegate: OrderPublishDelegate?
    @IBOutlet var feeTextField: UITextField!
    @IBOutlet var doneButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doneButton.enabled = false
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if !UtilBox.isNum(string, digital: true) {
            return false
        }
        
        if textField.text?.characters.count == 0 && range.location == 0 {
            doneButton.enabled = true
        } else if textField.text?.characters.count == 1 && range.location == 0 {
            doneButton.enabled = false
        }
        
        return true
    }
    
    @IBAction func done(sender: UIBarButtonItem) {
        delegate?.didSelectedFee(feeTextField.text!)
        self.navigationController?.popViewControllerAnimated(true)
    }

    // MARK: - Table view data source
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }

}
