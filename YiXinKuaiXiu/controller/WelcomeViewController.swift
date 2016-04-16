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
    @IBOutlet var handymanButton: UIButton!
    @IBOutlet var customerButton: UIButton!
    @IBOutlet var mainImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        handymanButton.layer.borderWidth = 1
        handymanButton.layer.cornerRadius = 3
        handymanButton.layer.borderColor = Constants.Color.Primary.CGColor
        
        customerButton.backgroundColor = Constants.Color.Primary
        customerButton.layer.cornerRadius = 3
        
        titleLabel.text = "壹 心 快 修"
        descLabel.text = "您 的 居 家 维 修 助 手"
        
        setImageViewAnimation()
        
        initNavBar()
    }
    
    func setImageViewAnimation() {
        let origin = mainImageView.frame
        mainImageView.frame = CGRect(x: origin.minY, y: origin.minY, width: origin.width * 0.8, height: origin.height * 0.8)
        
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
        Config.Role = "handyman"
        performSegueWithIdentifier("loginSegue", sender: self)
    }

    @IBAction func customerLogin(sender: UIButton) {
        Config.Role = "customer"
        performSegueWithIdentifier("loginSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destination = segue.destinationViewController as UIViewController
        
        if let navCon = destination as? UINavigationController {
            // 取出最上层的viewController，即FaceView
            destination = navCon.visibleViewController!
        }
        
        if let lvc = destination as? LoginViewController {
            lvc.role = "customer"
//            if let identifier = segue.identifier {
//                switch identifier {
//                case "sad": hvc.happiness = 0
//                case "happy": hvc.happiness = 100
//                case "nothing": hvc.happiness = 25
//                default: hvc.happiness = 50
//                }
//            }
        }
    }
}
