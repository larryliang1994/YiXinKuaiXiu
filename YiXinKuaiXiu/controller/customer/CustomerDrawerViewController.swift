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

    @IBOutlet var tableView: UITableView!
    @IBOutlet var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        
        tableView.tableFooterView = UIView()
    }
    
    func initView() {
        logoutButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
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
    
    // MARK: - Table view data source
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("drawerHeader", forIndexPath: indexPath)
            
            let telephoneLabel = cell.viewWithTag(Constants.Tag.CustomerDrawerTelephone) as! UILabel
            let nameLabel = cell.viewWithTag(Constants.Tag.CustomerDrawerName) as! UILabel
            
            telephoneLabel.text = Config.TelephoneNum == nil ? "手机号" : Config.TelephoneNum
            nameLabel.text = Config.Name == nil ? "姓名" : Config.Name
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("drawerItem", forIndexPath: indexPath)
            
            let label = cell.viewWithTag(Constants.Tag.CustomerDrawerTitle) as! UILabel
            let image = cell.viewWithTag(Constants.Tag.CustomerDrawerImage) as! UIImageView
            let badge = cell.viewWithTag(Constants.Tag.CustomerDrawerBadge) as! SwiftBadge
            
            if indexPath.row == 1 {
                label.text = "订单信息"
                let img = UIImage(named: "orderList")
                img?.resizableImageWithCapInsets(UIEdgeInsetsMake(2, 2, 2, 2))
                image.image = img
                 
                if Config.OrderNum! == 0 {
                    badge.hidden = true
                } else {
                    badge.font = UIFont(name: (badge.font?.fontName)!, size: 13)
                    badge.text = Config.OrderNum!.toString()
                    badge.badgeColor = Constants.Color.Primary
                }
            } else if indexPath.row == 2 {
                image.image = UIImage(named: "wallet")
                label.text = "我的钱包"
                
                badge.text = "¥ " + Config.Money!
                badge.textColor = Constants.Color.Orange
                badge.badgeColor = UIColor.whiteColor()
                badge.font = UIFont(name: (badge.font?.fontName)!, size: 15)
            } else if indexPath.row == 3 {
                label.text = "消息中心"
                image.image = UIImage(named: "messageCenter")
                
                if Config.MessagesNum! == 0 {
                    badge.hidden = true
                } else {
                    badge.font = UIFont(name: (badge.font?.fontName)!, size: 13)
                    badge.text = Config.MessagesNum!.toString()
                    badge.badgeColor = Constants.Color.Primary
                }
            } else if indexPath.row == 4 {
                label.text = "谊心商城"
                image.image = UIImage(named: "mall")
                badge.alpha = 0
            } else if indexPath.row == 5 {
                label.text = "项目招标"
                image.image = UIImage(named: "projectBinding")
                badge.alpha = 0
            } else if indexPath.row == 6 {
                image.image = UIImage(named: "blacklist")
                label.text = "信用名单查询"
                badge.alpha = 0
            }
            
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 3 {
            Config.MessagesNum = 0
            tableView.reloadData()
        }
        
        delegate?.didSelected(indexPath.row)
        tableView.cellForRowAtIndexPath(indexPath)?.selected = false
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return indexPath.row == 0 ? 120 : 44
    }
    
}

protocol CustomerDrawerDelegate{
    func didSelected(index: Int)
    func didLogout()
}


