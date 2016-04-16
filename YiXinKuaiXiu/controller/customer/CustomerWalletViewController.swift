//
//  CustomerWalletViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/16.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class CustomerWalletViewController: UITableViewController {
    
    @IBOutlet var withdrawButton: UIButton!
    @IBOutlet var buttonBackgroundView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        withdrawButton.layer.cornerRadius = 3
        withdrawButton.backgroundColor = Constants.Color.Primary

        self.tableView.contentInset = UIEdgeInsets(top: -1, left: 0, bottom: 0, right: 0)
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 9
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return indexPath.section == 0 ? 160 : 44
    }
}
