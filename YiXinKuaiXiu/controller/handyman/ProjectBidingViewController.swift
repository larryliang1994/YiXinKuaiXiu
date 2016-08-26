//
//  ProjectBidingViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/19.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class ProjectBidingViewController: UIViewController {
    
    @IBOutlet var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.automaticallyAdjustsScrollViewInsets = false
        
        let request = NSURLRequest(URL: NSURL(string: "https://www.yixinkuaixiu.com/xmzb.php")!)
        webView.loadRequest(request)
    }

}
