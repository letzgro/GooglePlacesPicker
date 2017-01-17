//
//  GooglePlacesPresentationController.swift
//
//  Created by Ihor Rapalyuk on 2/3/16.
//  Copyright © 2016 Lezgro. All rights reserved.
//
import UIKit

open class GooglePlacesPresentationController: UIPresentationController {

    lazy var dimmingView: UIView = {
        let view = UIView(frame: self.containerView!.bounds)
        view.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
        view.alpha = 0.0
        return view
    }()

    override open func presentationTransitionWillBegin() {
        // Add the dimming view and the presented view to the heirarchy
        guard let containerView = self.containerView,
            let presentedView = presentedView else {
            return
        }
        self.dimmingView.frame = containerView.bounds
        containerView.addSubview(self.dimmingView)
        containerView.addSubview(presentedView)

        // Fade in the dimming view alongside the transition
        if let transitionCoordinator = self.presentingViewController.transitionCoordinator {
            transitionCoordinator.animate(alongsideTransition: {(context: UIViewControllerTransitionCoordinatorContext!) -> Void in
                self.dimmingView.alpha  = 1.0
            }, completion:nil)
        }
    }

    override open func presentationTransitionDidEnd(_ completed: Bool)  {
        // If the presentation didn't complete, remove the dimming view
        if !completed {
            self.dimmingView.removeFromSuperview()
        }
    }

    override open func dismissalTransitionWillBegin()  {
        // Fade out the dimming view alongside the transition
        if let transitionCoordinator = self.presentingViewController.transitionCoordinator {
            transitionCoordinator.animate(alongsideTransition: {(context: UIViewControllerTransitionCoordinatorContext!) -> Void in
                self.dimmingView.alpha  = 0.0
            }, completion:nil)
        }
    }

    override open func dismissalTransitionDidEnd(_ completed: Bool) {
        // If the dismissal completed, remove the dimming view
        if completed {
            self.dimmingView.removeFromSuperview()
        }
    }

    override open var frameOfPresentedViewInContainerView : CGRect {
        guard let containerView = self.containerView else {
                return CGRect(x: 0, y: 0, width: 320, height: 280)
        }
        // We don't want the presented view to fill the whole container view, so inset it's frame
        var frame = containerView.bounds;
        
        frame = CGRect(x: 0, y: 0, width: frame.width, height: 280).insetBy(dx: 15.0, dy: 25.0)

        return frame
    }

    //MARK UIContentContainer protocol methods

    override open func viewWillTransition(to size: CGSize, with transitionCoordinator: UIViewControllerTransitionCoordinator) {
        guard let containerView = self.containerView else {
            return
        }
        super.viewWillTransition(to: size, with: transitionCoordinator)

        transitionCoordinator.animate(alongsideTransition: {(context: UIViewControllerTransitionCoordinatorContext!) -> Void in
            self.dimmingView.frame = containerView.bounds
        }, completion:nil)
    }
}
