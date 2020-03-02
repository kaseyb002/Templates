//
//  Template.swift
//  Templates
//
//  Created by Kasey Baughan on 2/23/20.
//  Copyright © 2020 Kasey Baughan. All rights reserved.
//

import Foundation

struct Template: Codable {
    let id: String
    let text: String
    
    init(text: String) {
        self.id = UUID().uuidString
        self.text = text
    }
    
    private init(id: String,
                 text: String) {
        self.id = id
        self.text = text
    }
}

extension Template: Equatable {
    
    static func ==(lhs: Template, rhs: Template) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Template {
    
    func update(text: String) -> Template {
        return .init(id: id, text: text)
    }
}
