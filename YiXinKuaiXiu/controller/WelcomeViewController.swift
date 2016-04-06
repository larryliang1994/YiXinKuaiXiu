//
//  WelcomeViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/3.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet var handymanButton: UIButton!
    @IBOutlet var customerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        handymanButton.layer.borderWidth = 1
        handymanButton.layer.cornerRadius = 5
        handymanButton.layer.borderColor = UIColor(red: 46/255, green: 204/255, blue: 139/255, alpha: 1.0).CGColor
        
        customerButton.backgroundColor = UIColor(red: 46/255, green: 204/255, blue: 139/255, alpha: 1.0)
        customerButton.layer.cornerRadius = 5
        
        initNavBar()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func login(sender: UIButton) {
        performSegueWithIdentifier("loginSegue", sender: self)
    }

    // 初始化NavigationBar
    func initNavBar() {
        let back = UIBarButtonItem()
        back.title = "返回"
        self.navigationItem.backBarButtonItem = back
        self.navigationController?.navigationBar.tintColor = UIColor.darkGrayColor()
    }
}
