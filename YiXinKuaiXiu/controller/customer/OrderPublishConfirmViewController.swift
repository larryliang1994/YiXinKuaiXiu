//
//  OrderPublishConfirmViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/5.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class OrderPublishConfirmViewController: UITableViewController {
    @IBOutlet var doPayButton: UIButton!
    @IBOutlet var descLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        doPayButton.layer.cornerRadius = 5
        doPayButton.backgroundColor = UIColor(red: 46/255, green: 204/255, blue: 139/255, alpha: 1.0)
        
        self.tableView.contentInset = UIEdgeInsets(top: -1, left: 0, bottom: 0, right: 0)
        
        self.tableView.layoutIfNeeded()
    }
    
    @IBAction func doPay(sender: UIButton) {
        UtilBox.alert(self, message: "hah")
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 120
        case 1:
            if indexPath.row == 0 {
                return descLabel.frame.size.height + 28
            } else if indexPath.row == 2 {
                return addressLabel.frame.size.height + 28
            } else if indexPath.row == 1{
                return 66
            } else {
                return 44
            }
        default:
            return 44
        }
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 1 : 5
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section != 1 ? 1 : 4
    }
    
}
