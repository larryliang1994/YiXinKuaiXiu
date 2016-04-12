//
//  OrderTypeViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/3.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class OrderTypeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.0)
        self.automaticallyAdjustsScrollViewInsets = false
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 16 : 10
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("orderTypeCell")
        
        cell?.layer.cornerRadius = 3
        cell?.contentView.layer.cornerRadius = 3
        
        let image = cell?.viewWithTag(Constants.Tag.OrderTypeCellImage) as! UIImageView
        let title = cell?.viewWithTag(Constants.Tag.OrderTypeCellTitle) as! UILabel
        let desc = cell?.viewWithTag(Constants.Tag.OrderTypeCellDesc) as! UILabel
        
        if indexPath.section == 0 {
            image.backgroundColor = UIColor(red: 255/255, green: 115/255, blue: 0/255, alpha: 1.0)
            title.text = "普通维修"
            desc.text = "即时发单，需支付上门检查费。维修费与物料费另算。"
        } else if indexPath.section == 1 {
            image.backgroundColor = UIColor(red: 0/255, green: 215/255, blue: 140/255, alpha: 1.0)
            title.text = "打包维修"
            desc.text = "即时发单，一次性支付所有费用。"
        } else if indexPath.section == 2 {
            image.backgroundColor = UIColor(red: 37/255, green: 137/255, blue: 255/255, alpha: 1.0)
            title.text = "预约维修"
            desc.text = "预约维修，不收取上门检查费。"
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.cellForRowAtIndexPath(indexPath)?.selected = false
        
        performSegueWithIdentifier(Constants.SegueID.PubilshOrderSegue, sender: self)
    }
    
}
