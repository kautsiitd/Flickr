//
//  UIImageView.swift
//  Roposo
//
//  Created by Kautsya Kanu on 18/10/17.
//  Copyright © 2017 Kautsya Kanu. All rights reserved.
//

import UIKit

extension UIImageView {
	public func setImageWithUrl(_ url: URL?,
	                            placeHolderImage: UIImage? = nil,
	                            completion: @escaping (_ image: UIImage) -> Void = { _ in
		}) {
		guard let url = url else {
			setImage(image: placeHolderImage)
			return
		}
		if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
			self.animate(image: cachedImage,
			             withAnimation: .transitionCrossDissolve,
			             completion: { _ in
							completion(cachedImage)
			})
		}
		else {
			self.downloadImageWith(url: url, placeHolderImage: placeHolderImage, completion: { image in
				imageCache.setObject(image,
				                     forKey: url.absoluteString as NSString)
				completion(image)
			})
		}
	}
	
	fileprivate func setImage(image: UIImage?) {
		guard let image = image else {
			return
		}
		DispatchQueue.main.async {
			self.image = image
		}
	}
	
	fileprivate func downloadImageWith(url: URL,
	                                   placeHolderImage: UIImage?,
	                                   completion: @escaping (_ image: UIImage) -> Void = { _ in
		}) {
		self.getDataFromUrl(url: url) { data, response, error in
			guard let data = data, error == nil else {
				self.setImage(image: placeHolderImage)
				return
			}
			guard let image = UIImage(data: data) else {
				self.setImage(image: placeHolderImage)
				return
			}
			self.animate(image: image,
						 withAnimation: .transitionCrossDissolve,
						 completion: { _ in
							completion(image)
			})
		}
	}
	
	fileprivate func getDataFromUrl(url: URL,
	                                completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
		URLSession.shared.dataTask(with: url) { data, response, error in
			completion(data, response, error)
			}.resume()
	}
	
	fileprivate func animate(image: UIImage,
	                         withAnimation: UIViewAnimationOptions,
	                         completion: @escaping (_ image: UIImage) -> Void = { _ in
		}) {
		UIView.transition(with: self,
		                  duration: 0.5,
		                  options: withAnimation,
		                  animations: {
							self.setImage(image: image)
		},
		                  completion: { _ in
							completion(image)
		})
	}
}
