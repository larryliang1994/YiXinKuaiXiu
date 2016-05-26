//
//  PartDetailPopoverCell.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/5/23.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class PartDetailPopoverCell: UITableViewCell {
    
    var part: Part?
    
    func initView() {
        self.textLabel?.text = (part?.name)! + " x " + (part?.num?.toString())!
        
        self.detailTextLabel?.text = "￥" + String((part?.price)! * Float((part?.num)!))
    }
    
}
