//
//  CustomerDrawerViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/3.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class CustomerDrawerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var delegate: CustomerDrawerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func logout(sender: UIButton) {
        UtilBox.funcAlert(self, message: "确认退出？",
                    okAction: UIAlertAction(title: "退出", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) in
                        print("logout")
                      }),
                    cancelAction: UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil))
    }
    
    // MARK: - Table view data source
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("drawerHeader", forIndexPath: indexPath)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("drawerItem", forIndexPath: indexPath)
            
            let label = cell.viewWithTag(Constants.Tag.CustomerDrawerTitle) as? UILabel
            if indexPath.row == 1 {
                label?.text = "订单信息"
            } else if indexPath.row == 2 {
                label?.text = "消息中心"
            } else if indexPath.row == 3 {
                label?.text = "壹心商城"
            }
            
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.didSelected(indexPath.row)
        tableView.cellForRowAtIndexPath(indexPath)?.selected = false
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return indexPath.row == 0 ? 120 : 55
    }
    
}

protocol CustomerDrawerDelegate{
    func didSelected(index: Int)
}
