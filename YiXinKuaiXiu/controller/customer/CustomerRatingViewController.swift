//
//  CustomerRatingViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/15.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class CustomerRatingViewController: UITableViewController {

    @IBOutlet var ratingBar: FloatRatingView!
    @IBOutlet var descTextView: BRPlaceholderTextView!
    
    
    
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
        let confirmBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: #selector(CustomerRatingViewController.done))
        
        self.navigationItem.rightBarButtonItem = confirmBtn
    }
    
    func done() {
        self.navigationController?.popViewControllerAnimated(true)
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 11
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
}
