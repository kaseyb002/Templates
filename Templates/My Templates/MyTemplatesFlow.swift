//
//  MyTemplatesFlow.swift
//  Templates
//
//  Created by Kasey Baughan on 2/24/20.
//  Copyright © 2020 Kasey Baughan. All rights reserved.
//

import UIKit

final class MyTemplatesFlow: Flow {}

// MARK: To Navigation
extension MyTemplatesFlow {
    
    func showMyTemplates() {
        let vc = makeVC()
        navVC.pushViewController(vc, animated: true)
    }
}

// MARK: Make VCs
extension MyTemplatesFlow {
    
    private func makeVC() -> MyTemplatesVC {
        return MyTemplatesVC(
            .init(),
            navConfig: .init(
                tappedViewTemplate: { [weak self] in
                    self?.goToViewTemplate(config: $0)
                },
                tappedSendTemplate: { [weak self] in
                    self?.navVC.text(phones: [], message: $0.text)
                },
                tappedAddTemplate: { [weak self] in
                    self?.goToAddEditTemplate(config: $0)
            }))
    }
}
