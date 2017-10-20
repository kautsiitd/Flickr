//
//  UIImageView.swift
//  Roposo
//
//  Created by Kautsya Kanu on 18/10/17.
//  Copyright © 2017 Kautsya Kanu. All rights reserved.
//

import SDWebImage

extension UIImageView {
	public func setImageWithUrl(_ url: URL?,
	                            placeHolderImage: UIImage? = nil,
	                            completion: @escaping (_ image: UIImage) -> Void = { _ in
		}) {
		guard let url = url else {
			self.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.9411764706, blue: 0.9411764706, alpha: 1)
			return
		}
		let formattedURLString = Commons.formatURLforImgix(url.absoluteString,
		                                                   viewWidth: frame.size.width,
		                                                   viewHeight: frame.size.height,
		                                                   contentMode: .scaleAspectFill)
		let newURL = URL(string: formattedURLString)
		guard let placeHolderImage = placeHolderImage else {
			downloadImageWith(url: newURL, placeholder: #imageLiteral(resourceName: "Placeholder"), completion: { image in
				completion(image)
			})
			return
		}
		downloadImageWith(url: newURL, placeholder: placeHolderImage, completion: { image in
			completion(image)
		})
	}
	
	fileprivate func downloadImageWith(url: URL?,
	                                   placeholder: UIImage,
	                                   completion: @escaping (_ image: UIImage) -> Void = { _ in
		}) {
		sd_setImage(with: url,
		            placeholderImage: placeholder,
		            options: SDWebImageOptions(rawValue: 0),
		            completed: { (image, _, cacheType, _) in
						switch cacheType {
						case .none:
							self.animate(image: image, withAnimation: .transitionCrossDissolve, completion: { _ in
								completion(image ?? #imageLiteral(resourceName: "Placeholder"))
							})
						default:
							break
						}
		})
	}
	
	fileprivate func animate(image: UIImage?,
	                         withAnimation: UIViewAnimationOptions,
	                         completion: @escaping (_ image: UIImage) -> Void = { _ in
		}) {
		UIView.transition(with: self,
		                  duration: 0.5,
		                  options: withAnimation,
		                  animations: {
							self.image = image
		},
		                  completion: { _ in
							completion(image ?? #imageLiteral(resourceName: "Placeholder"))
		})
	}
}
