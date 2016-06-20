//
//  HandymanDrawerViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/16.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class HandymanDrawerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var delegate: HandymanDrawerDelegate?
    
    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
    }

    var alert: OYSimpleAlertController?
    @IBAction func logout(sender: UIButton) {
        alert = OYSimpleAlertController()
        UtilBox.showAlertView(self, alertViewController: alert!, message: "确认退出？", cancelButtonTitle: "取消", cancelButtonAction: #selector(CustomerDrawerViewController.cancel), confirmButtonTitle: "退出", confirmButtonAction: #selector(CustomerDrawerViewController.doLogout))
    }
    
    // 点击退出按钮
    func doLogout() {
        alert?.dismissViewControllerAnimated(true, completion: nil)
        
        delegate?.didLogout()
    }
    
    // 点击取消
    func cancel() {
        alert?.dismissViewControllerAnimated(true, completion: nil)
        alert = nil
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return indexPath.row == 0 ? 120 : 44
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("handymanDrawerTopCell")!
            
            let telephoneLabel = cell.viewWithTag(Constants.Tag.HandymanDrawerTelephone) as! UILabel
            let nameLabel = cell.viewWithTag(Constants.Tag.HandymanDrawerName) as! UILabel
            
            telephoneLabel.text = Config.TelephoneNum == nil ? "手机号" : Config.TelephoneNum
            nameLabel.text = Config.Name == nil ? "姓名" : Config.Name
            
            return cell
        } else if indexPath.row == 1 || indexPath.row == 4 {
            let cell = tableView.dequeueReusableCellWithIdentifier("handymanDrawerBadgeCell")!
            
            let image = cell.viewWithTag(Constants.Tag.HandymanDrawerBadgeImage) as! UIImageView
            let title = cell.viewWithTag(Constants.Tag.HandymanDrawerBadgeTitle) as! UILabel
            let badge = cell.viewWithTag(Constants.Tag.HandymanDrawerBadge) as! SwiftBadge
            
            if indexPath.row == 1 {
                image.image = UIImage(named: "orderList")
                title.text = "订单信息"
                
                if Config.OrderNum! == 0 {
                    badge.hidden = true
                } else {
                    badge.text = Config.OrderNum!.toString()
                    badge.badgeColor = Constants.Color.Primary
                }
            } else {
                image.image = UIImage(named: "messageCenter")
                title.text = "消息中心"
                
                if Config.MessagesNum! == 0 {
                    badge.hidden = true
                } else {
                    badge.text = Config.MessagesNum!.toString()
                    badge.badgeColor = Constants.Color.Primary
                }
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("handymanDrawerLabelCell")!
            
            let image = cell.viewWithTag(Constants.Tag.HandymanDrawerLabelImage) as! UIImageView
            let title = cell.viewWithTag(Constants.Tag.HandymanDrawerLabelTitle) as! UILabel
            let label = cell.viewWithTag(Constants.Tag.HandymanDrawerLabel) as! UILabel
            
            if indexPath.row == 2 {
                image.image = UIImage(named: "wallet")
                title.text = "我的钱包"
                label.text = "¥ " + Config.Money!
                label.textColor = Constants.Color.Orange
            } else if indexPath.row == 3 {
                image.image = UIImage(named: "audit")
                title.text = "身份认证"
                if Config.Audited == 1 {
                    label.text = "已认证"
                } else if Config.Audited == 0 && Config.Name != nil && Config.Name != "" {
                    label.text = "审核中"
                } else {
                    label.text = "未认证"
                }
                label.textColor = Constants.Color.Primary
            } else if indexPath.row == 5 {
                image.image = UIImage(named: "projectBinding")
                title.text = "项目招标"
                label.alpha = 0
            } else if indexPath.row == 6 {
                image.image = UIImage(named: "mall")
                title.text = "壹心商城"
                label.alpha = 0
            } else if indexPath.row == 7 {
                image.image = UIImage(named: "blacklist")
                title.text = "信用黑名单"
                label.alpha = 0
            }
            
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 4 {
            Config.MessagesNum = 0
            tableView.reloadData()
        }
        
        delegate?.didSelected(indexPath.row)
        tableView.cellForRowAtIndexPath(indexPath)?.selected = false
    }
}

protocol HandymanDrawerDelegate{
    func didSelected(index: Int)
    func didLogout()
}
