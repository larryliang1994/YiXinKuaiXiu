//
//  AuditIDViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/19.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class AuditIDViewController: UITableViewController, AuditIDDelegate {
    
    @IBOutlet var maintenanceTypeLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    
    var checked = [false, false, false, false]

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
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 9
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            performSegueWithIdentifier(Constants.SegueID.ShowHandymanChooseMaintenanceTypeSegue, sender: self)
        } else if indexPath.row == 1 {
            performSegueWithIdentifier(Constants.SegueID.ShowHandymanChooseLocationSegue, sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destination = segue.destinationViewController as UIViewController
        
        if let navCon = destination as? UINavigationController {
            // 取出最上层的viewController，即FaceView
            destination = navCon.visibleViewController!
        }
        
        if let cmtvc = destination as? ChooseMaintenanceTypeViewController {
            cmtvc.delegate = self
            cmtvc.checked = self.checked
        } else if let clvc = destination as? ChooseLocationViewController {
            clvc.delegate = self
        }
    }
    
    func didSelectedMaintenanceType(string: String, checked: [Bool]) {
        if string != "" {
            maintenanceTypeLabel.text = string
            self.checked = checked
        } else {
            maintenanceTypeLabel.text = "请选择"
        }
    }
    
    func didSelectedLocation(name: String, location: CLLocation) {
        locationLabel.text = name
        
//        if maintenanceTypeLabel.text != "点击选择" && descTextView.text != nil {
//            if title != Constants.Types[2] && feeLabel.text == "点击选择" {
//                return
//            }
//            publishButtonItem.enabled = true
//        }
    }
}

protocol AuditIDDelegate{
    func didSelectedMaintenanceType(string: String, checked: [Bool])
    func didSelectedLocation(name: String, location: CLLocation)
}
