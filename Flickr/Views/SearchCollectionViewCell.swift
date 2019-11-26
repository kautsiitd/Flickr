//
//  SearchCollectionViewCell.swift
//  Flickr
//
//  Created by Kautsya Kanu on 23/11/19.
//  Copyright © 2019 Kautsya Kanu. All rights reserved.
//

import UIKit

class SearchCollectionViewCell: UICollectionViewCell {
    
    //MARK: Elements
    @IBOutlet fileprivate weak var imageView: UIImageView!
    
    //MARK" Properties
    fileprivate var searchElement: SearchElement?
        
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 5
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.searchElement = nil
        imageView.image = nil
    }
}

extension SearchCollectionViewCell {
    func setCellWith(searchElement: SearchElement) {
        self.searchElement = searchElement
        
        if let imageURL = URL(string: searchElement.imageURL) {
            imageView.getImageWith(imageURL,
                                   handleLoader: true,
                                   placeHolderImage: #imageLiteral(resourceName: "Placeholder"),
                                   completion: { [weak self] image, url, fetchedImageType in
                guard let searchElement = self?.searchElement else {
                    DispatchQueue.main.async {
                        self?.imageView.stopLoader()
                        self?.imageView.image = #imageLiteral(resourceName: "Placeholder")
                    }
                    return
                }
                if imageURL.absoluteString == searchElement.imageURL {
                    guard let image = image else {
                        DispatchQueue.main.async {
                            self?.imageView.stopLoader()
                            self?.imageView.image = #imageLiteral(resourceName: "Placeholder")
                        }
                        return
                    }
                    self?.imageView.animate(image: image,
                                            withAnimation: .transitionCrossDissolve)
                }
            })
        }
    }
}
