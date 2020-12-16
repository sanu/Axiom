//
//  Obfuscator.swift
//  ENBDVirtualPrepaidCreditCard
//
//  Created by Lincy Francis on 14/04/2020.
//  Copyright © 2020 Solutions 4 Mobility. All rights reserved.
//

import Foundation

class Obfuscator {
    
    private var clientIdByteArray: [UInt8] = [97, 57, 104, 87, 48, 85, 111, 73, 87, 77, 51, 69, 99, 50, 87, 121, 72, 55, 97, 108, 68, 103, 61, 61]
    
    private var secretKeyByteArray: [UInt8] = [68, 98, 71, 54, 82, 121, 115, 90, 78, 50, 115, 55, 114, 51, 111, 121, 47, 100, 84, 65, 118, 119, 61, 61]
    
    var oAuthKey: String {
        guard let client = String(bytes: clientIdByteArray, encoding: .utf8), let secret = String(bytes: secretKeyByteArray, encoding: .utf8) else { return "" }
        return "Basic " + (client + ":" + secret).toBase64()
    }
    
    var clientId: String {
        guard let client = String(bytes: clientIdByteArray, encoding: .utf8) else { return "" }
        return client
    }
    
    var clientSecret: String {
        guard let secret = String(bytes: secretKeyByteArray, encoding: .utf8) else { return "" }
        return secret
    }
}

extension String {
    
    func toBase64() -> String {
        return Data(utf8).base64EncodedString()
    }
}
