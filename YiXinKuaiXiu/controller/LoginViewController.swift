//
//  LoginViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/3.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet var getVerifyCodeButton: UIButton!
    @IBOutlet var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getVerifyCodeButton.backgroundColor = UIColor(red: 46/255, green: 204/255, blue: 139/255, alpha: 1.0)
        getVerifyCodeButton.layer.cornerRadius = 5
        
        loginButton.backgroundColor = UIColor(red: 46/255, green: 204/255, blue: 139/255, alpha: 1.0)
        loginButton.layer.cornerRadius = 5
    }

    @IBAction func login(sender: UIButton) {
        performSegueWithIdentifier("customerMainSegue", sender: self)
    }
 
}
