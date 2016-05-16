//
//  CustomerRatingViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/15.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class RatingViewController: UITableViewController, RatingDelegate {

    @IBOutlet var ratingBar: FloatRatingView!
    @IBOutlet var descTextView: BRPlaceholderTextView!
    
    var order: Order?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        
        initNVBar()
    }
    
    func initView() {
        descTextView.placeholder = "可以在此输入具体评价"
        descTextView.setPlaceholderFont(UIFont(name: (descTextView.font?.fontName)!, size: 15))
    }
    
    func initNVBar() {
        let confirmBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: #selector(RatingViewController.done))
        
        self.navigationItem.rightBarButtonItem = confirmBtn
    }
    
    func done() {
        self.pleaseWait()
        
        RatingModel(ratingDelegate: self).doRating((order?.date)!, star: Int(ratingBar.rating), desc: descTextView.text!)
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func onRatingResult(result: Bool, info: String) {
        self.clearAllNotice()
        if result {
            self.noticeSuccess("评价成功", autoClear: true, autoClearTime: 2)
            self.navigationController?.popViewControllerAnimated(true)
        } else {
            UtilBox.alert(self, message: info)
        }
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 11
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
}
