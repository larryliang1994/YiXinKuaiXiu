//
//  OYSimpleAlertController.swift
//  OYSimpleAlertController
//
//  Created by oyuk on 2015/09/09.
//  Copyright (c) 2015年 oyuk. All rights reserved.
//

import UIKit

let cornerRadius:CGFloat = 5

class LunchAnimation:NSObject,UIViewControllerAnimatedTransitioning {
    
    private var presenting = false
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        presenting ? presentTransition(transitionContext) : dismissTransition(transitionContext)
    }
    
    private func presentTransition(transitionContext: UIViewControllerContextTransitioning){
        
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! OYSimpleAlertController
        toVC.contentView!.transform = CGAffineTransformMakeScale(0.8, 0.8)
        
        let containerView = transitionContext.containerView()
        containerView!.insertSubview(toVC.view, aboveSubview: fromVC.view)
        
        UIView.animateWithDuration(
            
            transitionDuration(transitionContext),animations: { () -> Void in
                
            }) { (finished) -> Void in
                
                UIView.animateWithDuration(0.4,
                    delay: 0,
                    usingSpringWithDamping: 0.5,
                    initialSpringVelocity: 1.0,
                    options: UIViewAnimationOptions.AllowAnimatedContent,
                    animations: { () -> Void in
                        toVC.backgroundView.alpha = 1
                        toVC.contentView!.alpha = 1.0
                        toVC.contentView!.transform = CGAffineTransformIdentity
                    }, completion: { (finish) -> Void in
                        transitionContext.completeTransition(true)
                })
        }
    }
    
    private func dismissTransition(transitionContext: UIViewControllerContextTransitioning){
        
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as! OYSimpleAlertController
        
        UIView.animateWithDuration(
            
            transitionDuration(transitionContext),animations: { () -> Void in
                
            }) { (finished) -> Void in
                
                UIView.animateWithDuration(0.4,
                    delay: 0,
                    usingSpringWithDamping: 0.5,
                    initialSpringVelocity: 1.0,
                    options: UIViewAnimationOptions.AllowAnimatedContent,
                    animations: { () -> Void in
                        fromVC.backgroundView.alpha = 0
                        fromVC.contentView!.alpha = 0
                        fromVC.contentView!.transform = CGAffineTransformMakeScale(0.8, 0.8)
                    }, completion: { (finish) -> Void in
                        transitionContext.completeTransition(true)
                })
        }
        
    }
}

public class OYSimpleAlertController: UIViewController,UIViewControllerTransitioningDelegate {
   
    private class OYAlertTextView:UITextView {
        override func canBecomeFirstResponder() -> Bool {
            return false
        }
    }
    
    private let backgroundView = UIView()
    public var backgroundViewColor:UIColor = UIColor.blackColor().colorWithAlphaComponent(0.3)
    
    public var contentView :UIView?
    
    private let animater = LunchAnimation()
    
    func initView(contentView: UIView) {
        self.contentView = contentView
        
        self.transitioningDelegate = self
        self.definesPresentationContext = true
        self.providesPresentationContextTransitionStyle = true
        self.modalPresentationStyle = .Custom
    }
    
//    convenience public init(contentView: UIView) {
//        self.init()
//        
//        self.contentView = contentView
//        
//        self.transitioningDelegate = self
//        self.definesPresentationContext = true
//        self.providesPresentationContextTransitionStyle = true
//        self.modalPresentationStyle = .Custom
//    }
//    
//    required public init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    public override func viewDidLoad() {
        backgroundView.frame = self.view.bounds
        backgroundView.backgroundColor = backgroundViewColor
        self.view.addSubview(backgroundView)
        
        contentView!.backgroundColor = UIColor.whiteColor()
        contentView!.layer.cornerRadius = cornerRadius
        contentView!.center = self.view.center
        
        self.view.addSubview(contentView!)
    }
    
    public func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animater.presenting = true
        return animater
    }
    
    public func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animater.presenting = false
        return animater
    }
    
}
