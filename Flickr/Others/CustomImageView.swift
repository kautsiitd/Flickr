//
//  CustomImageView.swift
//  Flickr
//
//  Created by Kautsya Kanu on 02/01/20.
//  Copyright © 2020 Kautsya Kanu. All rights reserved.
//

import UIKit

class CustomImageView: UIImageView {
    //MARK: Properties
    private var urlString = ""
    //MARK: Elements
    private var loader: UIActivityIndicatorView!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLoader()
    }
    
    private func setupLoader() {
        loader = UIActivityIndicatorView()
        addSubview(loader)
        loader.hidesWhenStopped = true
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        loader.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}
    
extension CustomImageView {
    func setImage(with urlString: String) {
        image = nil
        backgroundColor = .lightGray
        self.urlString = urlString
        loader.startAnimating()
        //Checking cache
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            setImage(image: cachedImage, for: urlString)
            return
        }
        
        guard let url = URL(string: urlString) else {
            self.setImage(image: #imageLiteral(resourceName: "Placeholder.png"), for: urlString)
            return
        }
        let remoteImageTask = URLSession.shared.dataTask(with: url, completionHandler: { [weak self] data, response, error in
            guard let self = self else { return }
            guard let data = data,
                let remoteImage = UIImage(data: data) else {
                    self.setImage(image: #imageLiteral(resourceName: "Placeholder.png"), for: urlString, animate: true)
                    return
            }
            self.setImage(image: remoteImage, for: urlString, shouldCache: true, animate: true)
        })
        
        //Async Image fetching from CoreData or Remote
        DispatchQueue.global(qos: .userInteractive).async {
            remoteImageTask.resume()
        }
    }
    
    private func setImage(image: UIImage, for urlString: String,
                          shouldCache: Bool = false, animate: Bool = false) {
        if shouldCache {
            imageCache.setObject(image, forKey: urlString as NSString)
        }
        DispatchQueue.main.async {
            if urlString == self.urlString {
                self.loader.stopAnimating()
                if animate { self.animate(image: image) }
                else {
                    self.image = image
                    self.backgroundColor = .white
                }
            }
        }
    }
    
    private func animate(image: UIImage?) {
        UIView.transition(with: self, duration: 0.5, options: [.transitionCrossDissolve],
                          animations: { [weak self] in
                            self?.image = image
                            self?.backgroundColor = .white
            }, completion: nil)
    }
}
