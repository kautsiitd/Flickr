//
//  UIViewController.swift
//  Flickr
//
//  Created by Kautsya Kanu on 06/01/20.
//  Copyright © 2020 Kautsya Kanu. All rights reserved.
//

import UIKit
import SafariServices

extension UIViewController {
    func showAlert(with error: CustomError) {
        let alert = CustomAlert(with: error, actions: [.ok])
        present(alert, animated: true, completion: nil)
    }
    
    func open(url: URL?) {
        guard let url = url else {
            showAlert(with: .invalidLink)
            return
        }
        let safariViewController = SFSafariViewController(url: url)
        present(safariViewController, animated: true)
    }
}
