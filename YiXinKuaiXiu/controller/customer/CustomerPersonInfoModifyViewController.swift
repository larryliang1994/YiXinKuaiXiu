//
//  CustomerPersonInfoModifyViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/29.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class CustomerPersonInfoModifyViewController: UITableViewController, UITextFieldDelegate, UserInfoDelegate {
    
    @IBOutlet var contentTextField: UITextField!
    @IBOutlet var doneButton: UIBarButtonItem!
    
    var content: String?
    var delegate: CustomerPersonInfoDelegate?
    var indexPath: NSIndexPath?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
    }
    
    func initView() {
        contentTextField.text = content
        contentTextField.becomeFirstResponder()
        
        if content == nil {
            doneButton.enabled = false
        }
        
        if title == "手机号" {
            contentTextField.keyboardType = .PhonePad
        } else if title == "姓名" {
            contentTextField.keyboardType = .NamePhonePad
        } else if title == "年龄" {
            contentTextField.keyboardType = .NumberPad
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if range.location == 0 && textField.text == "" {
            if title != "手机号" {
                doneButton.enabled = true
            }
        } else if range.location == 0 && textField.text != "" {
            doneButton.enabled = false
        }
        
        if title == "手机号" {
            if range.location >= 11 {
                return false
            }
            
            let telephoneNum = contentTextField.text?.characters.count == 10 ?
                contentTextField.text! + "1" : contentTextField.text!
            
            if range.location >= 10
                && textField.text?.characters.count == 10
                && UtilBox.isTelephoneNum(telephoneNum){
                
                doneButton.enabled = true
            } else {
                doneButton.enabled = false
            }
        }
        
        return true
    }
    
    func onGetUserInfoResult(result: Bool, info: String){}
    
    func onModifyUserInfoResult(result: Bool, info: String){
        if result {
            if title == "姓名" {
                Config.Name = contentTextField.text!
            } else if title == "年龄" {
                Config.Age = contentTextField.text!
            } else if title == "手机号" {
                Config.TelephoneNum = contentTextField.text!
            } else if title == "企业名称" {
                Config.Company = contentTextField.text!
            } else if title == "住址" {
                Config.Location = contentTextField.text!
            }
            
            delegate?.didModify(indexPath!, value: contentTextField.text!)
            self.navigationController?.popViewControllerAnimated(true)
        } else {
            UtilBox.alert(self, message: info)
        }
        
        self.clearAllNotice()
    }
    
    func doneEdit() {
        if contentTextField.text != content {
            var key = ""
            if title == "姓名" {
                key = "nme"
            } else if title == "年龄" {
                key = "age"
            } else if title == "手机号" {
                key = "cod"
            } else if title == "企业名称" {
                key = "qym"
            }
            
            UserInfoModel(userInfoDelegate: self).doModifyUserInfo(["key": key, "value": contentTextField.text!])
            self.pleaseWait()
        } else {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        doneEdit()
        return true
    }
    
    @IBAction func done(sender: UIBarButtonItem) {
        doneEdit()
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
}
