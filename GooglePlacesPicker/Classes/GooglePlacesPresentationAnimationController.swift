//
//  Created by Pete Callaway on 26/06/2014.
//  Copyright (c) 2014 Dative Studios. All rights reserved.
//

import UIKit


public class GooglePlacesPresentationAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    let isPresenting: Bool
    let duration: NSTimeInterval = 0.5

    init(isPresenting: Bool) {
        self.isPresenting = isPresenting
        super.init()
    }

    //MARK UIViewControllerAnimatedTransitioning methods

    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return self.duration
    }

    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        if isPresenting {
            self.animatePresentationWithTransitionContext(transitionContext)
        } else {
            self.animateDismissalWithTransitionContext(transitionContext)
        }
    }

    //MARK Helper methods

    private func animatePresentationWithTransitionContext(transitionContext: UIViewControllerContextTransitioning) {
        let presentedController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let presentedControllerView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        guard let containerView = transitionContext.containerView() else {
            return
        }

        // Position the presented view off the top of the container view
        presentedControllerView.frame = transitionContext.finalFrameForViewController(presentedController)
        presentedControllerView.center.y -= containerView.bounds.size.height

        containerView.addSubview(presentedControllerView)

        self.animateWithPresentedControllerView(presentedControllerView, andContainerView: containerView
            , andTransitionContext: transitionContext)
    }

    private func animateDismissalWithTransitionContext(transitionContext: UIViewControllerContextTransitioning) {
        guard let presentedControllerView = transitionContext.viewForKey(UITransitionContextFromViewKey),
            containerView = transitionContext.containerView() else {
            return 
        }
        self.animateWithPresentedControllerView(presentedControllerView, andContainerView: containerView
            , andTransitionContext: transitionContext)
    }
    
    private func animateWithPresentedControllerView(presentedControllerView: UIView, andContainerView containerView: UIView, andTransitionContext transitionContext: UIViewControllerContextTransitioning) {
        // Animate the presented view off the bottom of the view
        UIView.animateWithDuration(self.duration, delay: 0.0, usingSpringWithDamping: 1.0,
            initialSpringVelocity: 0.0, options: .AllowUserInteraction, animations: {
                presentedControllerView.center.y += containerView.bounds.size.height
            }, completion: {(completed: Bool) -> Void in
                transitionContext.completeTransition(completed)
        })
    }
    
}
