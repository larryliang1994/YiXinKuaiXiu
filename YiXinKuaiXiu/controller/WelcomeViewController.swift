//
//  WelcomeViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/3.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descLabel: UILabel!
    @IBOutlet var mainImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        
        setImageViewAnimation()
        
        initNavBar()
    }
    
    func initView() {
        titleLabel.text = "谊 心 快 修"
        descLabel.text = "您 的 居 家 维 修 助 手"
    }
    
    func setImageViewAnimation() {
        let origin = mainImageView.frame
        let center = mainImageView.center
        mainImageView.frame.size = CGSize(width: origin.width * 0.8, height: origin.height * 0.8)
        mainImageView.center = center
        
        UIView.animateWithDuration(1) {
            self.mainImageView.frame = origin
        }
    }
    
    // 初始化NavigationBar
    func initNavBar() {
        let back = UIBarButtonItem()
        back.title = "返回"
        self.navigationItem.backBarButtonItem = back
        self.navigationController?.navigationBar.tintColor = UIColor.darkGrayColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func handymanLogin(sender: UIButton) {
        Config.Role = Constants.Role.Handyman
        performSegueWithIdentifier("loginSegue", sender: self)
    }

    @IBAction func customerLogin(sender: UIButton) {
        Config.Role = Constants.Role.Customer
        performSegueWithIdentifier("loginSegue", sender: self)
    }

}
