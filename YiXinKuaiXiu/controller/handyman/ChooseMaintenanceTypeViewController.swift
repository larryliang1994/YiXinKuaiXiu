//
//  ChooseMaintenanceTypeViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/28.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class ChooseMaintenanceTypeViewController: UITableViewController {

    let titles = ["门窗修理", "空调、冰箱修理", "彩电修理", "电路修理"]
    var checked = [false, false, false, false]
    
    var delegate: AuditIDDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: -1, left: 0, bottom: 0, right: 0)
    }
    
    @IBAction func done(sender: UIBarButtonItem) {
        var string = ""
        for i in 0...checked.count - 1 {
            string += checked[i] ? titles[i] + "，" : ""
        }
        
        if string.characters.last == "，" {
            string = string.substringToIndex(string.endIndex.advancedBy(-1))
        }
        
        delegate?.didSelectedMaintenanceType(string, checked: checked)
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("handymanChooseMaintenanceTypeCell", forIndexPath: indexPath)
        
        let titleLabel = cell.viewWithTag(Constants.Tag.HandymanChooseMaintenanceTypeCellTitle) as! UILabel
        let checkImage = cell.viewWithTag(Constants.Tag.HandymanChooseMaintenanceTypeCellCheck) as! UIImageView
        
        titleLabel.text = titles[indexPath.row]
        
        if checked[indexPath.row] {
            checkImage.image = UIImage(named: "checked")
        } else {
            checkImage.image = nil
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        checked[indexPath.row] = !checked[indexPath.row]
        tableView.reloadData()
    }
}
