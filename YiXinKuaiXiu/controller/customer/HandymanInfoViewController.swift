//
//  HandymanInfoViewController.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/5/16.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class HandymanInfoViewController: UITableViewController {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var ageLabel: UILabel!
    @IBOutlet var telephoneLabel: UILabel!
    @IBOutlet var idImageView: UIImageView!
    
    var name: String?, age: Int?, telephone: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel.text = name!
        ageLabel.text = age!.toString()
        telephoneLabel.text = telephone!
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
}
