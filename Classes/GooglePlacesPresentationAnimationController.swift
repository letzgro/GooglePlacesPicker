//
//  GooglePlacesPresentationAnimationController.swift
//
//  Created by Ihor Rapalyuk on 2/3/16.
//  Copyright © 2016 Lezgro. All rights reserved.
//

import UIKit


open class GooglePlacesPresentationAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    let isPresenting: Bool
    let duration: TimeInterval = 0.5

    init(isPresenting: Bool) {
        self.isPresenting = isPresenting
        super.init()
    }

    //MARK UIViewControllerAnimatedTransitioning methods

    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration
    }

    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isPresenting {
            self.animatePresentationWithTransitionContext(transitionContext)
        } else {
            self.animateDismissalWithTransitionContext(transitionContext)
        }
    }

    //MARK Helper methods

    fileprivate func animatePresentationWithTransitionContext(_ transitionContext: UIViewControllerContextTransitioning) {
        let presentedController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let presentedControllerView = transitionContext.view(forKey: UITransitionContextViewKey.to)!

        // Position the presented view off the top of the container view
        presentedControllerView.frame = transitionContext.finalFrame(for: presentedController)
        presentedControllerView.center.y -= transitionContext.containerView.bounds.size.height

        transitionContext.containerView.addSubview(presentedControllerView)

        self.animateWithPresentedControllerView(presentedControllerView, andContainerView:  transitionContext.containerView
            , andTransitionContext: transitionContext)
    }

    fileprivate func animateDismissalWithTransitionContext(_ transitionContext: UIViewControllerContextTransitioning) {
        guard let presentedControllerView = transitionContext.view(forKey: UITransitionContextViewKey.from) else {
            return 
        }
        self.animateWithPresentedControllerView(presentedControllerView, andContainerView: transitionContext.containerView
            , andTransitionContext: transitionContext)
    }
    
    fileprivate func animateWithPresentedControllerView(_ presentedControllerView: UIView, andContainerView containerView: UIView, andTransitionContext transitionContext: UIViewControllerContextTransitioning) {
        // Animate the presented view off the bottom of the view
        UIView.animate(withDuration: self.duration, delay: 0.0, usingSpringWithDamping: 1.0,
            initialSpringVelocity: 0.0, options: .allowUserInteraction, animations: {
                presentedControllerView.center.y += containerView.bounds.size.height
            }, completion: {(completed: Bool) -> Void in
                transitionContext.completeTransition(completed)
        })
    }
    
}
