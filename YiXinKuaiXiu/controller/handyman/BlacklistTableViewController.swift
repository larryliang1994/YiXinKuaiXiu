//
//  BlacklistTableViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/6/14.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class BlacklistTableViewController: UITableViewController, GetInitialInfoDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        self.pleaseWait()
        
        GetInitialInfoModel(getInitialInfoDelegate: self).getBlacklist()
    }
    
    func onGetBlacklistResult(result: Bool, info: String) {
        self.clearAllNotice()
        if result {
            if Config.Blacklist.count == 0 {
                tableView.backgroundView = UtilBox.getEmptyView("暂无黑名单内容")
            } else {
                tableView.backgroundView = nil
            }
            
            tableView.reloadData()
        } else {
            UtilBox.alert(self, message: info)
        }
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return Config.Blacklist.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("blacklistCell", forIndexPath: indexPath)
        
        let nameLabel = cell.viewWithTag(1) as! UILabel
        let telephoneLabel = cell.viewWithTag(2) as! UILabel
        let dateLabel = cell.viewWithTag(3) as! UILabel
        let descLabel = cell.viewWithTag(4) as! UILabel
        
        let blackPerson = Config.Blacklist[indexPath.section]
        
        if blackPerson.name == nil || blackPerson.name == "" || blackPerson.name == "无" {
            nameLabel.text = "姓名"
        } else {
            nameLabel.text = blackPerson.name
        }
        telephoneLabel.text = blackPerson.telephone
        dateLabel.text = UtilBox.getDateFromString(blackPerson.date!, format: Constants.DateFormat.YMD)
        descLabel.text = blackPerson.desc
        descLabel.textAlignment = .Justified
        
        return cell
    }
}
