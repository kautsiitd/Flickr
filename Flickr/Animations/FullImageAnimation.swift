//
//  FullImageAnimation.swift
//  Flickr
//
//  Created by Kautsya Kanu on 04/02/20.
//  Copyright © 2020 Kautsya Kanu. All rights reserved.
//

import Foundation
import UIKit

class FullImageAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    //MARK: Properties
    let duration = 1.0
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
    }
}
