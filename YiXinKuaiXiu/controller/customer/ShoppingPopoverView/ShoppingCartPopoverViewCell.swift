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
    
    var part: Part?
    
    var delegate: PartsMallDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func initView() {
        addButton.layer.cornerRadius = 22 / 2
        addButton.backgroundColor = Constants.Color.Primary
        addButton.addTarget(self, action: #selector(ShoppingCartPopoverViewCell.add), forControlEvents: .TouchUpInside)
        
        reduceButton.layer.cornerRadius = 22 / 2
        reduceButton.layer.borderColor = Constants.Color.Gray.CGColor
        reduceButton.layer.borderWidth = 0.5
        reduceButton.addTarget(self, action: #selector(ShoppingCartPopoverViewCell.reduce), forControlEvents: .TouchUpInside)
        
        titleLabel.text = part?.name
        
        priceLabel.text = "￥\((part?.price)!)"
        numLabel.text = part?.num?.toString()
    }
    
    func add() {
        if part?.num != 99 {
            part?.num! += 1
            numLabel.text = part?.num?.toString()
            
            delegate?.didChangeData(1, price: (part?.price)!)
        }
    }
    
    func reduce() {
        if part?.num != 0 {
            part?.num! -= 1
            numLabel.text = part?.num?.toString()
            
            delegate?.didChangeData(-1, price: -(part?.price)!)
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
