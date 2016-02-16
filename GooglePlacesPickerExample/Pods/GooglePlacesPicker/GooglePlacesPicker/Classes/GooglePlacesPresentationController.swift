//
//  Created by Pete Callaway on 26/06/2014.
//  Copyright (c) 2014 Dative Studios. All rights reserved.
//

import UIKit

public class GooglePlacesPresentationController: UIPresentationController {

    lazy var dimmingView: UIView = {
        let view = UIView(frame: self.containerView!.bounds)
        view.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
        view.alpha = 0.0
        return view
    }()

    override public func presentationTransitionWillBegin() {
        // Add the dimming view and the presented view to the heirarchy
        guard let containerView = self.containerView,
            let presentedView = presentedView() else {
            return
        }
        self.dimmingView.frame = containerView.bounds
        containerView.addSubview(self.dimmingView)
        containerView.addSubview(presentedView)

        // Fade in the dimming view alongside the transition
        if let transitionCoordinator = self.presentingViewController.transitionCoordinator() {
            transitionCoordinator.animateAlongsideTransition({(context: UIViewControllerTransitionCoordinatorContext!) -> Void in
                self.dimmingView.alpha  = 1.0
            }, completion:nil)
        }
    }

    override public func presentationTransitionDidEnd(completed: Bool)  {
        // If the presentation didn't complete, remove the dimming view
        if !completed {
            self.dimmingView.removeFromSuperview()
        }
    }

    override public func dismissalTransitionWillBegin()  {
        // Fade out the dimming view alongside the transition
        if let transitionCoordinator = self.presentingViewController.transitionCoordinator() {
            transitionCoordinator.animateAlongsideTransition({(context: UIViewControllerTransitionCoordinatorContext!) -> Void in
                self.dimmingView.alpha  = 0.0
            }, completion:nil)
        }
    }

    override public func dismissalTransitionDidEnd(completed: Bool) {
        // If the dismissal completed, remove the dimming view
        if completed {
            self.dimmingView.removeFromSuperview()
        }
    }

    override public func frameOfPresentedViewInContainerView() -> CGRect {
        guard let containerView = self.containerView else {
                return CGRect(x: 0, y: 0, width: 320, height: 280)
        }
        // We don't want the presented view to fill the whole container view, so inset it's frame
        var frame = containerView.bounds;
        
        frame = CGRectInset(CGRect(x: 0, y: 0, width: frame.width, height: 280), 15.0, 25.0)

        return frame
    }

    //MARK UIContentContainer protocol methods

    override public func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator transitionCoordinator: UIViewControllerTransitionCoordinator) {
        guard let containerView = self.containerView else {
            return
        }
        super.viewWillTransitionToSize(size, withTransitionCoordinator: transitionCoordinator)

        transitionCoordinator.animateAlongsideTransition({(context: UIViewControllerTransitionCoordinatorContext!) -> Void in
            self.dimmingView.frame = containerView.bounds
        }, completion:nil)
    }
}
