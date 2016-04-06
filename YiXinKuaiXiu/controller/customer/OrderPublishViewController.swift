//
//  OrderPublishViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/4.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class OrderPublishViewController: UITableViewController {

    @IBOutlet var descTextView: BRPlaceholderTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "普通维修"
        
        descTextView.placeholder = "在这儿输入问题详情"
        descTextView.setPlaceholderFont(UIFont(name: (descTextView.font?.fontName)!, size: 16))
        
        initNavBar()
    }
    
    func initNavBar() {
        let back = UIBarButtonItem()
        back.title = "返回"
        self.navigationItem.backBarButtonItem = back
        self.navigationController?.navigationBar.tintColor = UIColor.darkGrayColor()
    }
    
    func dismissKeyboard(){
        self.view.endEditing(true)
    }
    
    @IBAction func publish(sender: UIBarButtonItem) {
        //UtilBox.alert(self, message: "发布")
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == 2 {
                performSegueWithIdentifier(Constants.SegueID.EditPriceSegue, sender: self)
            } else if indexPath.row == 0 {
                performSegueWithIdentifier(Constants.SegueID.ChooseMaintenanceTyeSegue, sender: self)
            }
        }
    }
}
