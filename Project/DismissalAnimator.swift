//
//  DismissalAnimator.swift
//  Animation
//
//  Created by Miguel Chavez on 8/13/17.
//  Copyright © 2017 Miguel Chavez. All rights reserved.
//

import UIKit

import UIKit

class DismissalAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    var openingFrame: CGRect?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let containerView = transitionContext.containerView
        
        let animationDuration = self .transitionDuration(using: transitionContext)
        
        let snapshotView = fromViewController.view.resizableSnapshotView(from: fromViewController.view.bounds, afterScreenUpdates: true, withCapInsets: UIEdgeInsets.zero)
        containerView.addSubview(snapshotView!)
        
        fromViewController.view.alpha = 0.0
        
        UIView.animate(withDuration: animationDuration, animations: { () -> Void in
            snapshotView?.frame = self.openingFrame!
            snapshotView?.alpha = 0.0
        }, completion: { (finished) -> Void in
            snapshotView?.removeFromSuperview()
            fromViewController.view.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}


