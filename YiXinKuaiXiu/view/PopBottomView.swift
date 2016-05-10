//
//  PopBottomView.swift
//  PopView
//
//  Created by chengfeiheng on 16/3/28.
//  Copyright © 2016年 chengfeisoft. All rights reserved.
//

import UIKit

@objc protocol PopBottomViewDataSource{
    /**
     弹出显示的View
     
     - returns: UIView
     */
    func viewPop() -> UIView
    
    /**
     弹出的View高度
     
     - returns: CGFloat
     */
    func viewHeight() -> CGFloat
    
    /**
     点击背景，是否删除整个View
     
     - returns: Bool
     */
    optional func removeTapBackground() -> Bool
    
    /**
     背景为模糊还是黑色背景
     
     - returns: Bool
     */
    optional func isEffectView() -> Bool
}

@objc protocol PopBottomViewDelegate{
    /**
     页面弹出来的时候
     */
    optional func viewWillAppear()
    
    /**
     页面消失的时候
     */
    func viewWillDisappear()
}


class PopBottomView: UIView {
    
    var dataSource:PopBottomViewDataSource!
    var delegate:PopBottomViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews(){
        delegate?.viewWillAppear?()
    }
    
    func showInView(view:UIView){
        var effectView:UIVisualEffectView?
        var bgButton:UIButton?
        if let isEffectView = dataSource.isEffectView?() where isEffectView == true{
            self.backgroundColor = UIColor.clearColor()
            
            let effect = UIBlurEffect(style: .Light)
            effectView = UIVisualEffectView(effect: effect)
            effectView!.frame = self.bounds
            effectView!.tag = 100
            effectView!.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(PopBottomView.hideView)))
            self.addSubview(effectView!)
        }else{
            bgButton = UIButton(frame: self.bounds)
            bgButton!.tag = 300
            bgButton!.backgroundColor = UIColor.blackColor()
            bgButton!.alpha = 0.0
            bgButton!.addTarget(self, action: #selector(PopBottomView.hideView), forControlEvents: .TouchUpInside)
            self.addSubview(bgButton!)
        }
        
        let v = dataSource.viewPop()
        v.tag = 200
        var frame  = self.bounds
        frame.size.height = dataSource.viewHeight()
        v.frame = frame
        v.frame.origin.y = CGRectGetMaxY(self.bounds)
        self.addSubview(v)
        
        UIView.animateWithDuration(0.3) { () -> Void in
            if let btn = bgButton {
                btn.alpha = 0.5
            }
            var frame = v.frame
            frame.origin.y = self.frame.size.height - frame.height
            //frame.origin.y = 295
            v.frame = frame
        }
        
        view.addSubview(self)
    }
    
    /**
     隐藏View
     */
    func hide(){
        self.hideView()
    }
    
    func hideView(){
        var btn = UIButton()
        var view = UIView()
        for v in self.subviews {
            if v.tag == 300 {
                btn = v as! UIButton
            }
            
            if v.tag == 200 {
                view = v
            }
            
        }
        
        var isDel = true
        if let d = dataSource.removeTapBackground?(){
            isDel = d
        }
        
        if isDel {
            self.delegate?.viewWillDisappear()
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                btn.alpha = 0
                var frame = view.frame
                frame.origin.y = CGRectGetMaxY(self.bounds)
                view.frame = frame
                
            }) { (finished) -> Void in
                btn.removeFromSuperview()
                view.removeFromSuperview()
                self.removeFromSuperview()
            }
        }
    }
}

