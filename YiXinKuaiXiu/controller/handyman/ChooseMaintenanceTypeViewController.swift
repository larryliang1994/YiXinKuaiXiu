//
//  ChooseMaintenanceTypeViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/28.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class ChooseMaintenanceTypeViewController: UITableViewController {

    var checked = Array(count: Config.MTypes!.count, repeatedValue: false)
    
    var delegate: ChooseMTypeDelegete?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: -1, left: 0, bottom: 0, right: 0)
    }
    
    @IBAction func done(sender: UIBarButtonItem) {
        var nameString = ""
        var idString = ""
        for i in 0...checked.count - 1 {
            if checked[i] {
                nameString += Config.MTypeNames![i] + "，"
                idString += "[" + (Config.MTypes![i].id)! + "],"
            }
        }
        
        if nameString.characters.last == "，" {
            nameString = nameString.substringToIndex(nameString.endIndex.advancedBy(-1))
        }
        
        if idString.characters.last == "," {
            idString = idString.substringToIndex(idString.endIndex.advancedBy(-1))
        }
        
        delegate?.didSelectedMaintenanceType(nameString, idString: idString, checked: checked)
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Config.MTypeNames!.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("handymanChooseMaintenanceTypeCell", forIndexPath: indexPath)
        
        let titleLabel = cell.viewWithTag(Constants.Tag.HandymanChooseMaintenanceTypeCellTitle) as! UILabel
        let checkImage = cell.viewWithTag(Constants.Tag.HandymanChooseMaintenanceTypeCellCheck) as! UIImageView
        
        titleLabel.text = Config.MTypeNames![indexPath.row]
        
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

protocol ChooseMTypeDelegete {
    func didSelectedMaintenanceType(nameString: String, idString: String, checked: [Bool])
}
