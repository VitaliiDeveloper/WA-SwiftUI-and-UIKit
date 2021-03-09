//
//  AnimatedTransitioning.swift
//  SwiftUI-WeatherApp
//
//  Created by Vitalii Lavreniuk on 2/28/21.
//

import UIKit

class AnimatedTransitioning: NSObject {
    private let animationDuration: Double
    private let animationType: AnimationType

    enum AnimationType {
        case present
        case dismiss
    }

    init(animationDuration: Double, animationType: AnimationType) {
        self.animationType = animationType
        self.animationDuration = animationDuration
    }
}

extension AnimatedTransitioning: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TimeInterval(exactly: animationDuration) ?? 0
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to), let fromViewController = transitionContext.viewController(forKey: .from) else {
            transitionContext.completeTransition(false)
            return
        }

        switch animationType {
        case .present:
            transitionContext.containerView.addSubview(toViewController.view)
            self.presentAnimation(context: transitionContext, viewToAnimate: toViewController.view)
        case .dismiss:
            transitionContext.containerView.addSubview(toViewController.view)
            transitionContext.containerView.addSubview(fromViewController.view)
            self.dismissAnimation(context: transitionContext, viewFromAnimate: fromViewController.view)
        }
    }

    private func presentAnimation(context: UIViewControllerContextTransitioning, viewToAnimate: UIView) {
        self.rotationAnimation(context: context, type: .present, view: viewToAnimate)
    }

    private func dismissAnimation(context: UIViewControllerContextTransitioning, viewFromAnimate: UIView) {
        self.rotationAnimation(context: context, type: .dismiss, view: viewFromAnimate)
    }

    private func rotationAnimation(context: UIViewControllerContextTransitioning, type: AnimatedTransitioning.AnimationType, view: UIView) {
        view.clipsToBounds = true
        view.layer.position = .zero
        view.layer.anchorPoint = .zero

        if type == .present {
            view.transform = CGAffineTransform(rotationAngle: 3 * .pi / 2)
        }

        let duration = transitionDuration(using: context)
        UIView.animate(withDuration: duration, animations: {
            view.transform = (type == .present) ? CGAffineTransform(rotationAngle: 2 * .pi) : CGAffineTransform(rotationAngle: 3 * .pi / 2)
        }, completion: { _ in
            context.completeTransition(true)
        })
    }
}
