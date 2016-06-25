//
//  ReceiptTableViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/6/21.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class ReceiptTableViewController: UITableViewController, ReceiptDelegate, InvoiceDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        self.pleaseWait()
        ReceiptModel(receiptDelegate: self).getReceiptList()
    }
    
    func onGetReceiptListResult(result: Bool, info: String) {
        self.clearAllNotice()
        if result {
            if Config.ReceiptList.count == 0 {
                self.tableView.backgroundView = UtilBox.getEmptyView("你还没申请过发票")
            } else {
                self.tableView.backgroundView = nil
            }
            
            tableView.reloadData()
        } else {
            UtilBox.alert(self, message: info)
        }
    }
    
    func didInvoice() {
        self.pleaseWait()
        ReceiptModel(receiptDelegate: self).getReceiptList()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destination = segue.destinationViewController as UIViewController
        
        if let navCon = destination as? UINavigationController {
            destination = navCon.visibleViewController!
        }
        
        if let ivc = destination as? InvoiceViewController {
            ivc.delegate = self
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Config.ReceiptList.count
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("receiptCell", forIndexPath: indexPath)
        
        let titleLabel = cell.viewWithTag(1) as! UILabel
        let feeLabel = cell.viewWithTag(2) as! UILabel
        let descLabel = cell.viewWithTag(3) as! UILabel
        let stateLabel = cell.viewWithTag(4) as! UILabel
        let dateLabel = cell.viewWithTag(5) as! UILabel
        let reasonLabel = cell.viewWithTag(6) as! UILabel
        
        let receipt = Config.ReceiptList[indexPath.row]
        titleLabel.text = receipt.title
        feeLabel.text = "￥" + receipt.fee!
        descLabel.text = receipt.desc
        dateLabel.text = UtilBox.getDateFromString((receipt.date)!, format: Constants.DateFormat.YMD)
        reasonLabel.text = receipt.reason
        
        if receipt.state == .Dealing {
            stateLabel.text = "待处理"
            stateLabel.textColor = Constants.Color.Orange
        } else if receipt.state == .Passed {
            stateLabel.text = "已通过"
            stateLabel.textColor = UIColor.lightGrayColor()
        } else if receipt.state == .NotPassed {
            stateLabel.text = "未通过"
            stateLabel.textColor = Constants.Color.Orange
        }
        
        return cell
    }
}
