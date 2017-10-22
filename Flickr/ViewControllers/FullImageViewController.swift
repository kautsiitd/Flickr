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
	@IBOutlet weak var imageView: UIImageView!
	
	// MARK: Properties
	var imageLink: URL?
	var imageViewFrame = CGRect(x: 0,
	                                   y: 73,
	                                   width: 375,
	                                   height: 521)
	
	// MARK: Init
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}
	
	override func viewDidLoad() {
		imageView.setImageWithUrl(imageLink)
	}
}

extension FullImageViewController {
	@IBAction func closeButtonPressed() {
		self.dismiss(animated: true,
		             completion: nil)
	}
}
