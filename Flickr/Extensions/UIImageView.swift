//
//  UIImageView.swift
//  Flickr
//
//  Created by Kautsya Kanu on 18/10/17.
//  Copyright © 2017 Kautsya Kanu. All rights reserved.
//

import UIKit

public enum FetchedImageType {
	case cache
	case downloaded
}

/// Setting and Downloading Image from URL in UIImageView
extension UIImageView {
	public func setImageWithUrl(_ url: URL?,
	                            placeHolderImage: UIImage? = nil,
	                            completion: @escaping (_ image: UIImage?, _ url: URL?) -> Void = { _ in
		}) {
		guard let url = url else {
			guard let placeHolderImage = placeHolderImage else {
				self.stopLoader()
				self.image = nil
				completion(nil, nil)
				return
			}
			self.stopLoader()
			self.image = placeHolderImage
			completion(placeHolderImage, nil)
			return
		}
		self.getImageWith(url, placeHolderImage: placeHolderImage, completion: { image, url, type in
			guard let image = image else {
				guard let placeHolderImage = placeHolderImage else {
					self.stopLoader()
					self.image = nil
					completion(nil, url)
					return
				}
				self.stopLoader()
				self.image = placeHolderImage
				completion(placeHolderImage, url)
				return
			}
			self.animate(image: image,
			             withAnimation: .transitionCrossDissolve,
			             completion: { _ in
							completion(image, url)
			})
		})
	}
	
	public func animate(image: UIImage,
	                    withAnimation: UIViewAnimationOptions,
	                    completion: @escaping (_ completed: Bool) -> Void = { _ in
		}) {
		UIView.transition(with: self,
		                  duration: 0.5,
		                  options: withAnimation,
		                  animations: {
							DispatchQueue.main.async {
								self.stopLoader()
								self.image = image
							}
		},
		                  completion: { _ in
							completion(true)
		})
	}
	
	public func getImageWith(_ url: URL,
	                         placeHolderImage: UIImage? = nil,
	                         completion: @escaping (_ image: UIImage?, _ url: URL, _ type: FetchedImageType) -> Void = { _ in
		}) {
		if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
			completion(cachedImage, url, .cache)
		}
		else {
			self.showLoader()
			self.downloadImageWith(url: url, placeHolderImage: placeHolderImage, completion: { image in
				guard let image = image else {
					completion(nil, url, .downloaded)
					return
				}
				imageCache.setObject(image,
				                     forKey: url.absoluteString as NSString)
				self.stopLoader()
				completion(image, url, .downloaded)
			})
		}
	}
	
	fileprivate func downloadImageWith(url: URL,
	                                   placeHolderImage: UIImage?,
	                                   completion: @escaping (_ image: UIImage?) -> Void = { _ in
		}) {
		DispatchQueue.global(qos: .userInteractive).async {
			self.getDataFromUrl(url: url) { data, response, error in
				guard let data = data, error == nil else {
					completion(placeHolderImage)
					return
				}
				guard let image = UIImage(data: data) else {
					completion(placeHolderImage)
					return
				}
				completion(image)
			}
		}
	}
	
	fileprivate func getDataFromUrl(url: URL,
	                                completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
		URLSession.shared.dataTask(with: url) { data, response, error in
			completion(data, response, error)
			}.resume()
	}
}

/// Showing Loader on UIImageView untill Image loads
extension UIImageView {
	var activityIndicatorTag: Int {
		return 999999
	}
	public func showLoader() {
		DispatchQueue.main.async {
			let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
			activityIndicator.tag = self.activityIndicatorTag
			activityIndicator.center = self.center
			activityIndicator.hidesWhenStopped = true
			activityIndicator.startAnimating()
			self.addSubview(activityIndicator)
		}
	}
	public func stopLoader() {
		DispatchQueue.main.async {
			if let activityIndicator = self.subviews.filter(
				{ $0.tag == self.activityIndicatorTag}).first as? UIActivityIndicatorView {
				activityIndicator.stopAnimating()
				activityIndicator.removeFromSuperview()
			}
		}
	}
}
