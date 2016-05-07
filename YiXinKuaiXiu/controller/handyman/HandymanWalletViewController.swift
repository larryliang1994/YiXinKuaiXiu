//
//  HandymanWalletViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/19.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class HandymanWalletViewController: UITableViewController {

    @IBOutlet var withdrawButton: UIButton!
    @IBOutlet var buttonBackgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        
        initNavBar()
        
        self.tableView.contentInset = UIEdgeInsets(top: -1, left: 0, bottom: 0, right: 0)
    }
    
    func initView() {
        withdrawButton.layer.cornerRadius = 3
        withdrawButton.backgroundColor = Constants.Color.Primary
    }
    
    func initNavBar() {
        let back = UIBarButtonItem()
        back.title = "钱包"
        self.navigationItem.backBarButtonItem = back
        self.navigationController?.navigationBar.tintColor = UIColor.darkGrayColor()
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var segue = ""
        if indexPath.row == 0 {
            segue = Constants.SegueID.ShowHandymanD2DAccountSegue
            performSegueWithIdentifier(segue, sender: self)
        }
    }
}
