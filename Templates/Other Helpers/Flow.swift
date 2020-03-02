//
//  Flow.swift
//  Templates
//
//  Created by Kasey Baughan on 2/24/20.
//  Copyright © 2020 Kasey Baughan. All rights reserved.
//

import UIKit

class Flow {
    
    init(navVC: UINavigationController) {
        self.navVC = navVC
    }
    
    let navVC: UINavigationController
    
    private lazy var myTemplatesFlow = MyTemplatesFlow(navVC: navVC)
    private lazy var addEditTemplateFlow = AddEditTemplateFlow()
    private lazy var viewTemplateFlow = ViewTemplateFlow(navVC: navVC)
}

extension Flow {
    
    func goToMyTemplates() {
        myTemplatesFlow.showMyTemplates()
    }
    
    func goToAddEditTemplate(config: AddEditTemplateVC.Config) {
        addEditTemplateFlow.show(config: config, on: navVC)
    }
    
    func goToViewTemplate(config: ViewTemplateFlow.Config) {
        viewTemplateFlow.show(config: config)
    }
}
