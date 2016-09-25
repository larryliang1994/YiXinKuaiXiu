//
//  HollowButton.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/5/20.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import Foundation

class HollowButton: UIButton {
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    required internal init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    internal override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    private func setupView() {
//        rippleColor = UIColor(white: 0.9, alpha: 1)
//        
//        buttonCornerRadius = 3
//        trackTouchLocation = true
//        touchUpAnimationTime = 0.5
//        ripplePercent = 1.0
//        shadowRippleEnable = true
        
        layer.cornerRadius = 3
        
        layer.borderColor = Constants.Color.Primary.CGColor
        layer.borderWidth = 1
        setTitleColor(Constants.Color.Primary, forState: .Normal)
    }
}
