//
//  ProtocolViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/7/5.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class ProtocolViewController: UIViewController {
    @IBOutlet var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let request = NSURLRequest(URL: NSURL(string: "https://wap.koudaitong.com/v2/home/1f1cjsz5r?common%2Furl%2Fcreate=&scan=3&from=kdt")!)
        webView.loadRequest(request)
    }

}
