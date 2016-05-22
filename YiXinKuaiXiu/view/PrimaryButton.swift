//
//  PrimaryButton.swift
//  YiXinKuaiXiu
//
//  Created by 梁浩 on 16/5/20.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

import Foundation

class PrimaryButton: ZFRippleButton {
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
        rippleColor = UIColor(white: 0.9, alpha: 0.2)
        rippleBackgroundColor = Constants.Color.Primary
        buttonCornerRadius = 3
        trackTouchLocation = true
        touchUpAnimationTime = 0.5
        ripplePercent = 1.0
        
        setTitleColor(UIColor.whiteColor(), forState: .Normal)
        backgroundColor = Constants.Color.Primary
    }
}