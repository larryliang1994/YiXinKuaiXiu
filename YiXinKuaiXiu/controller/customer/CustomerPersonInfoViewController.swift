//
//  CustomerPersonInfoViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/16.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class CustomerPersonInfoViewController: UITableViewController, CustomerPersonInfoDelegate {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var ageLabel: UILabel!
    @IBOutlet var telephoneLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var companyLabel: UILabel!
    
    var selectedIndex: NSIndexPath?
    
    var delegate: CustomerPersonInfoDelgate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()

        initNavBar()
    }
    
    func initView() {
        nameLabel.text = Config.Name == nil ? "请选择" : Config.Name
        ageLabel.text = Config.Age == nil ? "请选择" : Config.Age
        telephoneLabel.text = Config.TelephoneNum == nil ? "请选择" : Config.TelephoneNum
        locationLabel.text = Config.Location == nil ? "请选择" : Config.Location
        companyLabel.text = Config.Company == nil ? "请选择" : Config.Company
    }
    
    func initNavBar() {
        let back = UIBarButtonItem()
        back.title = "返回"
        self.navigationItem.backBarButtonItem = back
        self.navigationController?.navigationBar.tintColor = UIColor.darkGrayColor()
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }

    // MARK: - Table view data source
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var segue = ""
        switch indexPath.row {
        case 0: fallthrough
        case 1: fallthrough
        case 2: fallthrough
        case 4:
            selectedIndex = indexPath
            segue = Constants.SegueID.CustomerModifyPersonInfoSefue
        case 3: segue = Constants.SegueID.CustomerChoosePersonInfoLocationSefue
        case 5: segue = Constants.SegueID.ShowCustomerWalletSegue
        default:
            segue = ""
        }
        
        performSegueWithIdentifier(segue, sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destination = segue.destinationViewController as UIViewController
        
        if let navCon = destination as? UINavigationController {
            // 取出最上层的viewController，即FaceView
            destination = navCon.visibleViewController!
        }
        
        if let cpimvc = destination as? CustomerPersonInfoModifyViewController {
            let cell = tableView.cellForRowAtIndexPath(selectedIndex!)
            let text = cell?.textLabel?.text
            var content = cell?.detailTextLabel?.text
            
            if content == "请选择" {
                content = nil
            }
            
            cpimvc.title = text
            cpimvc.content = content
            cpimvc.delegate = self
            cpimvc.indexPath = selectedIndex
        } else if let cpilvc = destination as? CustomerPersonInfoLocationViewController {
            cpilvc.delegate = self
        }
    }
    
    func didModify(indexPath: NSIndexPath, value: String) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.detailTextLabel?.text = value
        
        delegate?.didModify()
    }
    
    func didChooseLocation(name: String, location: CLLocation) {
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 3, inSection: 0))
        cell?.detailTextLabel?.text = name
    }
}

protocol MyDelegate {
    func didModify()
}

protocol CustomerPersonInfoDelegate {
    func didModify(indexPath: NSIndexPath, value: String)
    func didChooseLocation(name: String, location: CLLocation)
}
