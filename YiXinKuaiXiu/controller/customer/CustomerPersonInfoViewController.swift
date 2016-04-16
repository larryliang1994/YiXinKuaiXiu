//
//  CustomerPersonInfoViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/16.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class CustomerPersonInfoViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        initNavBar()
    }
    
    func initNavBar() {
        let back = UIBarButtonItem()
        back.title = "返回"
        self.navigationItem.backBarButtonItem = back
        self.navigationController?.navigationBar.tintColor = UIColor.darkGrayColor()
    }

    // MARK: - Table view data source
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var segue = ""
        switch indexPath.row {
        case 5:
            segue = Constants.SegueID.ShowCustomerWalletSegue
            performSegueWithIdentifier(segue, sender: self)
        default:
            segue = ""
        }
        
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
}
