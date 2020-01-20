//
//  FullImageViewController.swift
//  Flickr
//
//  Created by Kautsya Kanu on 20/10/17.
//  Copyright © 2017 Kautsya Kanu. All rights reserved.
//

import UIKit
import CustomImageView

class FullImageViewController: UIViewController {
	
	// MARK: Elements
	@IBOutlet private weak var imageView: CustomImageView!
	
	// MARK: Properties
	var imageLink: URL?
	
	override func viewDidLoad() {
        imageView.setImage(with: imageLink)
	}
}
