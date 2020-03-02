//
//  UserDefaults+Extensions.swift
//  Templates
//
//  Created by Kasey Baughan on 3/1/20.
//  Copyright © 2020 Kasey Baughan. All rights reserved.
//

import Foundation

// MARK: Codable Objects
extension UserDefaults {
    
    func getObject<T: Codable>(type: T.Type,
                               key: String) -> T? {
        if let savedData = object(forKey: key) as? Data {
            let decoder = JSONDecoder()
            if let object = try? decoder.decode(T.self, from: savedData) {
                return object
            }
            return nil
        }
        return nil
    }
    
    func setObject<T: Codable>(_ codable: T?, key: String) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(codable) {
            set(encoded, forKey: key)
        } else {
            set(nil, forKey: key)
        }
    }
}
