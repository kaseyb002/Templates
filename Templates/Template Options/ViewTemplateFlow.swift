//
//  ViewTemplateFlow.swift
//  Templates
//
//  Created by Kasey Baughan on 3/1/20.
//  Copyright © 2020 Kasey Baughan. All rights reserved.
//

import UIKit

final class ViewTemplateFlow: Flow {}

// MARK: To Navigation
extension ViewTemplateFlow {
    
    func show(config: ViewTemplateFlow.Config) {
        navVC.actionSheet(
            title: "Template Options",
            actions: [
                .init(title: "Edit") {
                    self.edit(template: config.template)
                },
                .init(title: "Delete", style: .destructive) {
                    self.delete(template: config.template)
                },
        ])
    }
}

// MARK: Make VCs
extension ViewTemplateFlow {
    
    
}

// MARK: Actions
extension ViewTemplateFlow {
    
    private func edit(template: Template) {
        goToAddEditTemplate(config: .init(mode: .edit(template)))
    }
    
    private func delete(template: Template) {
        TemplatesAPI.delete(template: template)
    }
}

// MARK: Config
extension ViewTemplateFlow {
    
    struct Config {
        let template: Template
    }
}
