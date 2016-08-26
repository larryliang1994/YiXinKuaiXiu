//
//  UserAgreementViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/8/25.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class UserAgreementViewController: UIViewController {
    @IBOutlet var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.automaticallyAdjustsScrollViewInsets = false
        
        let request = NSURLRequest(URL: NSURL(string: "https://www.yixinkuaixiu.com/yhxy.php")!)
        webView.loadRequest(request)
    }

}
