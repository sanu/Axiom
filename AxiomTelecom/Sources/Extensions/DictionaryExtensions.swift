//
//  DictionaryExtensions.swift
//  AxiomTelecom
//
//  Created by Sanu Sathyaseelan on 04/09/2020.
//  Copyright © 2020 Sanu. All rights reserved.
//

import Foundation

extension Dictionary {
    func decode<T: Decodable>(_ : T.Type) -> T? {
        do {
            let data = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            return nil
        }
    }
}
