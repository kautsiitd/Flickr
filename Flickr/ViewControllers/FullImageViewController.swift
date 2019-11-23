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
	@IBOutlet fileprivate weak var imageView: UIImageView!
	
	// MARK: Properties
	var imageLink: URL?
	
	// MARK: Init
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}
	
	override func viewDidLoad() {
        imageView.setImageWithUrl(imageLink,
                                  handleLoader: true,
                                  completion: {_ in})
	}
}

extension FullImageViewController {
	@IBAction func closeButtonPressed() {
		dismiss(animated: true,
		             completion: nil)
	}
}
