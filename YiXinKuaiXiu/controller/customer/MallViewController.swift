//
//  MallViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/8.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class MallViewController: UIViewController {
    @IBOutlet var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let request = NSURLRequest(URL: NSURL(string: "http://cn.bing.com")!)
        webView.loadRequest(request)
    }

}
