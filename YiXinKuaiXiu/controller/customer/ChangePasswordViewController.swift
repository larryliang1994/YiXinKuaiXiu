//
//  CustomerChangePasswordViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/30.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UITableViewController, UITextFieldDelegate, UserInfoDelegate {
    @IBOutlet var oldPasswordTextField: UITextField!
    @IBOutlet var newPasswordTextField: UITextField!
    @IBOutlet var newPassword2TextField: UITextField!
    @IBOutlet var doneButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        doneButton.enabled = false
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if newPasswordTextField.text?.characters.count == 5
            && newPassword2TextField.text?.characters.count == 6 {
            doneButton.enabled = true
        } else if newPasswordTextField.text?.characters.count == 6
            && newPassword2TextField.text?.characters.count == 5 {
            doneButton.enabled = true
        } else if newPasswordTextField.text?.characters.count == 6
            && newPassword2TextField.text?.characters.count == 6 {
            doneButton.enabled = true
        } else {
            doneButton.enabled = false
        }
        
        if range.location == 6 && textField.text?.characters.count == 6 {
            return false
        }
        
        return true
    }
    
    @IBAction func done(sender: UIBarButtonItem) {
        if newPasswordTextField.text != newPassword2TextField.text {
            UtilBox.alert(self, message: "两次密码填写不一致")
        } else {
            self.pleaseWait()
            UserInfoModel(userInfoDelegate: self).doChangePassword(oldPasswordTextField.text!, new: newPasswordTextField.text!)
        }
    }
    
    func onChangePassword(result: Bool, info: String) {
        self.clearAllNotice()
        if result {
            self.noticeSuccess("修改成功", autoClear: true, autoClearTime: 2)
            Config.Password = newPasswordTextField.text
            self.navigationController?.popViewControllerAnimated(true)
        } else {
            UtilBox.alert(self, message: info)
        }
    }
    
    // MARK: - Table view data source
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
}
