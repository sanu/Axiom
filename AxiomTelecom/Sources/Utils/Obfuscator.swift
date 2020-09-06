//
//  Obfuscator.swift
//  AxiomTelecom
//
//  Created by Sanu Sathyaseelan on 06/09/2020.
//  Copyright © 2020 Sanu. All rights reserved.
//

import Foundation

class Obfuscator {
    
    static let shared = Obfuscator()
    private init() {}
    
    private var secretKeyByteArray: [UInt8] = [36, 50, 98, 36, 49, 48, 36, 108, 100, 119, 98, 71, 46, 66, 47, 50, 104, 78, 82, 118, 83, 50, 100, 122, 88, 68, 120, 111, 79, 53, 80, 56, 55, 115, 89, 71, 119, 111, 69, 48, 50, 83, 108, 105, 90, 73, 104, 46, 56, 118, 108, 118, 115, 83, 99, 116, 71, 113, 70, 50]
    
    var secretKey: String {
        guard let key = String(bytes: secretKeyByteArray, encoding: .utf8) else { return "" }
        return key
    }
}
