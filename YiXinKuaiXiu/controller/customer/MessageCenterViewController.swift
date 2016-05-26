//
//  CustomerMessageCenterViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/5/12.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class MessageCenterViewController: UITableViewController, GetInitialInfoDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        self.pleaseWait()
        GetInitialInfoModel(getInitialInfoDelegate: self).getMessage()
    }
    
    func onGetMessageResult(result: Bool, info: String) {
        self.clearAllNotice()
        if result {
            tableView.reloadData()
        } else {
            UtilBox.alert(self, message: info)
        }
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
        let cell = tableView.dequeueReusableCellWithIdentifier("messageCenterCell", forIndexPath: indexPath)
        
        let titleLabel = cell.viewWithTag(Constants.Tag.MessageCenterCellTitle) as! UILabel
        let dateLabel = cell.viewWithTag(Constants.Tag.MessageCenterCellDate) as! UILabel
        let descLabel = cell.viewWithTag(Constants.Tag.MessageCenterCellDesc) as! UILabel
        
        let message = Config.Messages[indexPath.section]
        titleLabel.text = message.title
        dateLabel.text = UtilBox.getDateFromString(message.date!, format: Constants.DateFormat.Full)
        descLabel.text = message.desc

        return cell
    }
    

}
