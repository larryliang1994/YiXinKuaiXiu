//
//  ShoppingCartPopoverViewCell.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/4/15.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import UIKit

class ShoppingCartPopoverViewCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var addButton: UIButton!
    @IBOutlet var reduceButton: UIButton!
    @IBOutlet var numLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        addButton.layer.cornerRadius = 20 / 2
        addButton.backgroundColor = Constants.Color.Primary
        
        reduceButton.layer.cornerRadius = 20 / 2
        reduceButton.layer.borderColor = Constants.Color.Gray.CGColor
        reduceButton.layer.borderWidth = 0.5
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
