//
//  HandymanD2DAccountViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/20.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class D2DAccountViewController: UITableViewController, WalletDelegate {
    var accountList: [D2DAccount] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        WalletModel(walletDelegate: self).doGetD2DAccount()
    }
    
    func onGetD2DAccountResult(result: Bool, info: String, accountList: [D2DAccount]) {
        if result {
            self.accountList = accountList
            
            if accountList.count == 0 {
                self.tableView.backgroundView = UtilBox.getEmptyView("还没有新流水条目")
            } else {
                self.tableView.backgroundView = nil
            }
            
            tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountList.count
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("customerD2DAccountCell", forIndexPath: indexPath)
        
        let weekLabel = cell.viewWithTag(Constants.Tag.CustomerD2DAccountCellWeek) as! UILabel
        let dateLabel = cell.viewWithTag(Constants.Tag.CustomerD2DAccountCellDate) as! UILabel
        let feeLabel = cell.viewWithTag(Constants.Tag.CustomerD2DAccountCellFee) as! UILabel
        let typeLabel = cell.viewWithTag(Constants.Tag.CustomerD2DAccountCellType) as! UILabel
        let statusLabel = cell.viewWithTag(Constants.Tag.CustomerD2DAccountCellStatus) as! UILabel
        
        let account = accountList[indexPath.row]
        weekLabel.text = account.week
        dateLabel.text = UtilBox.getDateFromString(account.date!, format: Constants.DateFormat.MD)
        feeLabel.text = account.fee
        typeLabel.text = account.type
        statusLabel.text = account.status == 0 ? "审核中" : ""
        
        return cell
    }
    
    func onWithDrawResult(result: Bool, info: String) {}
}
