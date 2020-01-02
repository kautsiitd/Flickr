//
//  FullImageViewController.swift
//  Flickr
//
//  Created by Kautsya Kanu on 20/10/17.
//  Copyright © 2017 Kautsya Kanu. All rights reserved.
//

import UIKit

class FullImageViewController: UIViewController {
	
	// MARK: Elements
	@IBOutlet fileprivate weak var imageView: CustomImageView!
	
	// MARK: Properties
	var imageLink: String!
	
	// MARK: Init
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override func viewDidLoad() {
        imageView.setImage(with: imageLink)
	}
}

extension FullImageViewController {
	@IBAction func closeButtonPressed() {
		dismiss(animated: true, completion: nil)
	}
}
