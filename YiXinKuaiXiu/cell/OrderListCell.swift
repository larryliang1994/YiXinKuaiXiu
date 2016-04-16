//
//  OrderListCell.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/13.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class OrderListCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var reminderLabel: UILabel!
    @IBOutlet var rightButton: UIButton!
    @IBOutlet var leftButton: UIButton!
    @IBOutlet var orderStatusLabel: UILabel!
    @IBOutlet var serviceTypeLabel: UILabel!
    @IBOutlet var orderTypeLabel: UILabel!
    @IBOutlet var descLabel: UILabel!
    @IBOutlet var costTableView: UITableView!
    
    func initCell(){
        costTableView.delegate = self
        costTableView.dataSource = self
        costTableView.layer.cornerRadius = 3
        costTableView.backgroundColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1.0)
        
        costTableView.estimatedRowHeight = costTableView.rowHeight
        costTableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 30
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("costCell")
        cell?.textLabel?.text = "上门检查费"
        cell?.detailTextLabel?.text = "¥10.00(已支付)"
        
        return cell!
    }

}
