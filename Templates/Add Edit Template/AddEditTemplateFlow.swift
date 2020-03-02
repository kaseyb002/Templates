//
//  AddEditTemplateFlow.swift
//  Templates
//
//  Created by Kasey Baughan on 3/1/20.
//  Copyright © 2020 Kasey Baughan. All rights reserved.
//

import UIKit

final class AddEditTemplateFlow: ModalFlow {}

// MARK: To Navigation
extension AddEditTemplateFlow {
    
    func show(config: AddEditTemplateVC.Config, on presentingVC: UIViewController) {
        let vc = makeVC(config: config)
        navVC.setViewControllers([vc], animated: false)
        presentingVC.present(navVC, animated: true, completion: nil)
    }
}

// MARK: Make VCs
extension AddEditTemplateFlow {
    
    func makeVC(config: AddEditTemplateVC.Config) -> AddEditTemplateVC {
        return .init(
            config,
            navConfig: .init(
                done: { [weak self] in self?.navVC.dismissAndRemoveViewControllers() }))
    }
}
