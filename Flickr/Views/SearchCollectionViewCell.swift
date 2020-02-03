//
//  SearchCollectionViewCell.swift
//  Flickr
//
//  Created by Kautsya Kanu on 23/11/19.
//  Copyright © 2019 Kautsya Kanu. All rights reserved.
//

import UIKit
import CustomImageView

class LoaderCollectionViewCell: UICollectionViewCell {
    //MARK: Elements
    @IBOutlet private weak var loader: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        loader.isHidden = false
        loader.startAnimating()
        layer.cornerRadius = 5
    }
    
    override func prepareForReuse() {
        loader.isHidden = false
        loader.startAnimating()
    }
}


class SearchCollectionViewCell: UICollectionViewCell {
    
    //MARK: Elements
    @IBOutlet private weak var imageView: CustomImageView!
    
    //MARK" Properties
    var searchElement: SearchElement? {
        didSet { updateCell() }
    }
        
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 5
    }
    
    override func prepareForReuse() {
        searchElement = nil
    }
    
    private func updateCell() {
        imageView.setImage(with: searchElement?.imageURL)
    }
}
