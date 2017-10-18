//
//  TransitionDelegate.swift
//  Animation
//
//  Created by Miguel Chavez on 8/13/17.
//  Copyright © 2017 Miguel Chavez. All rights reserved.
//

import UIKit

class TransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    var openingFrame: CGRect?
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let presentationAnimator = PresentationAnimator()
        presentationAnimator.openingFrame = openingFrame!
        return presentationAnimator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let dismissAnimator = DismissalAnimator()
        dismissAnimator.openingFrame = openingFrame!
        return dismissAnimator
    }
}

