//
//  TemplatesAPI.swift
//  Templates
//
//  Created by Kasey Baughan on 2/23/20.
//  Copyright © 2020 Kasey Baughan. All rights reserved.
//

import Foundation

final class TemplatesAPI {
    private static let userData = UserDefaults.standard
    private static let templatesKey = "templates"
}

extension TemplatesAPI {
    
    static func save(templates: [Template]) {
        userData.setObject(templates, key: templatesKey)
        NotificationCenter.default.post(name: .templatesUpdated, object: nil)
    }
    
    static func createTemplate(from text: String) {
        let new = Template(text: text)
        var templates = getTemplates()
        templates.insert(new, at: 0)
        save(templates: templates)
    }
    
    static func update(template: Template) {
        var templates = getTemplates()
        guard let index = templates.firstIndex(of: template) else { return }
        templates[index] = template
        save(templates: templates)
    }
    
    static func getTemplates() -> [Template] {
        return userData.getObject(type: [Template].self, key: templatesKey) ?? []
    }
    
    static func delete(template: Template) {
        var templates = getTemplates()
        guard let index = templates.firstIndex(of: template) else { return }
        templates.remove(at: index)
        save(templates: templates)
    }
}
