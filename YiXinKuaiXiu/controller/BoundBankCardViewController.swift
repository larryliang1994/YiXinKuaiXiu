//
//  BoundBankCardViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/5/21.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class BoundBankCardViewController: UITableViewController, BankCardChangeDelegate {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var bankLabel: UILabel!
    @IBOutlet var numLabel: UILabel!
    
    var delegate: BankCardChangeDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initNavBar()

        initView()
    }
    
    func initNavBar() {
        let back = UIBarButtonItem()
        back.title = "返回"
        self.navigationItem.backBarButtonItem = back
        self.navigationController?.navigationBar.tintColor = UIColor.darkGrayColor()
    }
    
    func initView() {
        nameLabel.text = Config.BankOwner
        bankLabel.text = Config.BankName
        numLabel.text = Config.BankNum
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destination = segue.destinationViewController as UIViewController
        
        if let navCon = destination as? UINavigationController {
            // 取出最上层的viewController，即FaceView
            destination = navCon.visibleViewController!
        }
        
        if let bbcvc = destination as? BindBankCardViewController {
            bbcvc.delegate = self
        }
    }

    func didChange() {
        nameLabel.text = Config.BankOwner
        bankLabel.text = Config.BankName
        numLabel.text = Config.BankNum
        
        delegate?.didChange()
    }
}

protocol BankCardChangeDelegate {
    func didChange()
}
