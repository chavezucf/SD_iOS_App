//
//  PresentationAnimator.swift
//  Animation
//
//  Created by Miguel Chavez on 8/13/17.
//  Copyright © 2017 Miguel Chavez. All rights reserved.
//

import UIKit

class PresentationAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    var openingFrame: CGRect?
 
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let containerView = transitionContext.containerView
        
        let animationDuration = self .transitionDuration(using: transitionContext)
        
        let fromViewFrame = fromViewController.view.frame
        
        UIGraphicsBeginImageContext(fromViewFrame.size)
        fromViewController.view.drawHierarchy(in: fromViewFrame, afterScreenUpdates: true)
        let snapshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let snapshotView = toViewController.view.resizableSnapshotView(from: toViewController.view.frame, afterScreenUpdates: true, withCapInsets: UIEdgeInsets.zero)
        snapshotView?.frame = openingFrame!
        containerView.addSubview(snapshotView!)
        
        toViewController.view.alpha = 0.0
        containerView.addSubview(toViewController.view)
        
        
        UIView.animate(withDuration: animationDuration, delay: 0.0, usingSpringWithDamping: 2.8, initialSpringVelocity: 2.0,
                       animations: { () -> Void in
                        snapshotView?.frame = fromViewController.view.frame
        }, completion: { (finished) -> Void in
            snapshotView?.removeFromSuperview()
            toViewController.view.alpha = 1.0
            
            transitionContext.completeTransition(finished)
        })
    }
}
