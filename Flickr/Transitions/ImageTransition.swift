//
//  ImageTransition.swift
//  Flickr
//
//  Created by Kautsya Kanu on 22/10/17.
//  Copyright © 2017 Kautsya Kanu. All rights reserved.
//

import Foundation
import UIKit

class ImageTransition: NSObject, UIViewControllerAnimatedTransitioning {
	
	fileprivate let fromUIImageViewRect: CGRect!
	fileprivate let toUIImageViewRect: CGRect!
	
	init(fromUIImageViewRect: CGRect, toUIImageViewRect: CGRect) {
		self.fromUIImageViewRect = fromUIImageViewRect
		self.toUIImageViewRect = toUIImageViewRect
	}
	
	func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
		return 1
	}
	
	func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		guard let fromViewController = transitionContext.viewController(forKey: .from),
			let toViewController = transitionContext.viewController(forKey: .to) else {
				return
		}
		let container = transitionContext.containerView
		
		guard let toVCImageSnapShot = toViewController.view.resizableSnapshotView(from: toUIImageViewRect, afterScreenUpdates: true, withCapInsets: UIEdgeInsets.zero) else {
			return
		}
		container.addSubview(toVCImageSnapShot)
		
		guard let fromVCImageSnapShot = fromViewController.view.resizableSnapshotView(from: fromUIImageViewRect, afterScreenUpdates: true, withCapInsets: UIEdgeInsets.zero) else {
			return
		}
		container.addSubview(fromVCImageSnapShot)
		
		UIView.animate(withDuration: transitionDuration(using: transitionContext),
		               animations: {
						fromVCImageSnapShot.frame = toVCImageSnapShot.frame
		}, completion: { _ in })
	}
}

extension ImageTransition: UIViewControllerTransitioningDelegate {
	func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		return self
	}
}
