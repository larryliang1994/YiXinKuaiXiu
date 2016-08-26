//
//  MallViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/8.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class MallViewController: UIViewController, GetInitialInfoDelegate {
    @IBOutlet var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        GetInitialInfoModel(getInitialInfoDelegate: self).getMallUrl()
    }
    
    func onGetMallUrlResult(result: Bool, info: String) {
        if result {
            let request = NSURLRequest(URL: NSURL(string: info)!)
            webView.loadRequest(request)

        } else {
            UtilBox.alert(self, message: info)
        }
    }

}
