//
//  BindBankCardViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/5/21.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class BindBankCardViewController: UITableViewController, UserInfoDelegate {
    
    @IBOutlet var nameLabel: UITextField!
    @IBOutlet var bankLabel: UITextField!
    @IBOutlet var numLabel: UITextField!
    
    var delegate: BankCardChangeDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
    }
    
    func initView() {
        nameLabel.text = Config.BankOwner
        bankLabel.text = Config.BankName
        numLabel.text = Config.BankNum
    }

    @IBAction func bind(sender: UIBarButtonItem) {
        if nameLabel.text == nil || nameLabel.text == "" {
            UtilBox.alert(self, message: "请输入持卡人姓名")
        } else if bankLabel.text == nil || bankLabel.text == "" {
            UtilBox.alert(self, message: "请输入开户行")
        } else if numLabel.text == nil || numLabel.text == "" {
            UtilBox.alert(self, message: "请输入卡号")
        } else if !UtilBox.isBankCardNum(numLabel.text!) {
            UtilBox.alert(self, message: "请输入有效卡号")
        } else {
            self.pleaseWait()
            
            UserInfoModel(userInfoDelegate: self).doBindBankCard(nameLabel.text!, bank: bankLabel.text!, num: numLabel.text!)
        }
    }
    
    func onBindBankCardResult(result: Bool, info: String) {
        self.clearAllNotice()
        if result {
            self.noticeSuccess("提交成功", autoClear: true, autoClearTime: 2)
            
            Config.BankOwner = nameLabel.text
            Config.BankName = bankLabel.text
            Config.BankNum = numLabel.text
            
            delegate?.didChange()
            
            self.navigationController?.popViewControllerAnimated(true)
        } else {
            UtilBox.alert(self, message: info)
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
}
