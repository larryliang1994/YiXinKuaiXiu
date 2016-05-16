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
        return 6
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
                badge.text = "3"
                badge.badgeColor = Constants.Color.Orange
            } else {
                image.image = UIImage(named: "messageCenter")
                title.text = "消息中心"
                if Config.Messages.count == 0 {
                    badge.hidden = true
                } else {
                    badge.text = Config.Messages.count.toString()
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
                label.text = Config.Audited == 0 ? "未认证" : "已认证"
                label.textColor = Constants.Color.Primary
            } else {
                image.image = UIImage(named: "mall")
                title.text = "项目招标"
                label.alpha = 0
            }
            
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.didSelected(indexPath.row)
        tableView.cellForRowAtIndexPath(indexPath)?.selected = false
    }
}

protocol HandymanDrawerDelegate{
    func didSelected(index: Int)
    func didLogout()
}
