//
//  UINavigationController+Extensions.swift
//  Templates
//
//  Created by Kasey Baughan on 3/1/20.
//  Copyright © 2020 Kasey Baughan. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    func dismissAndRemoveViewControllers(animated: Bool = true) {
        dismiss(animated: animated) {
            self.setViewControllers([], animated: false)
        }
    }
}
