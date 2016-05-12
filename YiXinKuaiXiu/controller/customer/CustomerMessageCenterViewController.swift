//
//  CustomerMessageCenterViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/5/12.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class CustomerMessageCenterViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return Config.Messages.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("customerMessageCenterCell", forIndexPath: indexPath)
        
        let titleLabel = cell.viewWithTag(Constants.Tag.CustomerMessageCenterCellTitle) as! UILabel
        let dateLabel = cell.viewWithTag(Constants.Tag.CustomerMessageCenterCellDate) as! UILabel
        let descLabel = cell.viewWithTag(Constants.Tag.CustomerMessageCenterCellDesc) as! UILabel
        
        let message = Config.Messages[indexPath.section]
        titleLabel.text = message.title
        dateLabel.text = UtilBox.getDateFromString(message.date!, format: Constants.DateFormat.Full)
        descLabel.text = message.desc

        return cell
    }
    

}
