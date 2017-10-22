//
//  GradientView.swift
//  Flickr
//
//  Created by Kautsya Kanu on 18/10/17.
//  Copyright © 2017 Kautsya Kanu. All rights reserved.
//

import UIKit

extension UIView {
	func applyGradient(colours: [UIColor], startPoint: CGPoint = CGPoint(x: 0, y: 0.5), endPoint: CGPoint = CGPoint(x: 1, y: 0.5), dynamicMaxWidth: CGFloat? = nil, dynamicMaxHeight: CGFloat? = nil) {
		let gradient: CAGradientLayer = CAGradientLayer()
		let frame = self.bounds
		gradient.frame = CGRect(x: frame.minX, y: frame.minY, width: dynamicMaxWidth ?? frame.width, height: dynamicMaxHeight ?? frame.height)
		gradient.colors = colours.map { $0.cgColor }
		gradient.startPoint = startPoint
		gradient.endPoint = endPoint
		self.layer.insertSublayer(gradient, at: 0)
	}
}

@IBDesignable
class GradientView: UIView {
	@IBInspectable var startColor: UIColor = UIColor.clear
	@IBInspectable var endColor: UIColor = UIColor.clear
	//NOTE: x and y should be between 0 and 1 inclusive
	@IBInspectable var startPoint: CGPoint = CGPoint(x: 0.5, y: 0)
	@IBInspectable var endPoint: CGPoint = CGPoint(x: 0.5, y: 1)
	
	override class var layerClass: AnyClass {
		return CAGradientLayer.self
	}
	
	override func layoutSubviews() {
		(layer as! CAGradientLayer).colors = [startColor.cgColor, endColor.cgColor]
		(layer as! CAGradientLayer).startPoint = startPoint
		(layer as! CAGradientLayer).endPoint = endPoint
	}
}
