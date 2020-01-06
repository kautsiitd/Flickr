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
    @IBOutlet private weak var imageView: CustomImageView!
    
    //MARK" Properties
    private var searchElement: SearchElement?
        
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 5
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        searchElement = nil
        imageView.image = nil
    }
}

extension SearchCollectionViewCell {
    func setCell(with searchElement: SearchElement) {
        self.searchElement = searchElement
        imageView.setImage(with: searchElement.imageURL)
    }
}
