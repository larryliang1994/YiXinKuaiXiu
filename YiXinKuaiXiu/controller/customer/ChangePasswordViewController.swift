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
        if Config.Password != nil && Config.Password != oldPasswordTextField.text {
            UtilBox.alert(self, message: "原密码错误")
        } else if newPasswordTextField.text != newPassword2TextField.text {
            UtilBox.alert(self, message: "两次密码填写不一致")
        } else {
            UserInfoModel(userInfoDelegate: self).doModifyUserInfo(["key": "pwd", "value": newPasswordTextField.text!])
            self.pleaseWait()
        }
    }
    
    func onModifyUserInfoResult(result: Bool, info: String) {
        self.clearAllNotice()
        if result {
            Config.Password = newPasswordTextField.text
            self.navigationController?.popViewControllerAnimated(true)
            self.noticeSuccess("修改成功", autoClear: true, autoClearTime: 2)
        } else {
            UtilBox.alert(self, message: info)
        }
    }
    
    func onGetUserInfoResult(result: Bool, info: String) {}
    
    func onUpdateLocationInfoResult(result: Bool, info: String) {}
    
    // MARK: - Table view data source
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
}
