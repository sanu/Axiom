//
//  AXError.swift
//  AxiomTelecom
//
//  Created by Sanu Sathyaseelan on 06/09/2020.
//  Copyright © 2020 Sanu. All rights reserved.
//

import Foundation

final class AXError: Error {
    
    var code = 0
    var message = ""
    var key = ""
    
    init(code: Int = 0, key: String, message: String) {
        self.code = code
        self.key = key
        self.message = message
    }
}

extension AXError {
    var localizedDescription: String {
        message
    }
}

extension AXError {
    static var unknownError: AXError { AXError(key: AXError.keys.unknownError, message: "Something wrong Happened") }
    static var decodingFailureError: AXError {  AXError(key: AXError.keys.jsonParsing, message: "Decoding failed") }
    static var urlError: AXError {  AXError(key: AXError.keys.urlError, message: "Unable to build url") }
    static var encodingError: AXError { AXError(key: AXError.keys.unknownError, message: "Unable to encode request") }
}

extension AXError {
    struct keys {
        static let unknownError = "unknown_error"
        static let jsonParsing = "json_parsing_error"
        static let urlError = "url_error"
        static let commonError = "common_error"
    }
}
