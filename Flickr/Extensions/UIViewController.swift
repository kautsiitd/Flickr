//
//  UIViewController.swift
//  Flickr
//
//  Created by Kautsya Kanu on 06/01/20.
//  Copyright © 2020 Kautsya Kanu. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlert(with error: CustomError) {
        let alert = CustomAlert(with: error, actions: [.ok])
        present(alert, animated: true, completion: nil)
    }
}
