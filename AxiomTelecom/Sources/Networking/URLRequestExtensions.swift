//
//  URLRequestExtensions.swift
//  AxiomTelecom
//
//  Created by Sanu Sathyaseelan on 06/09/2020.
//  Copyright © 2020 Sanu. All rights reserved.
//

import Foundation

extension URLRequest: URLRequestBuilder {
    func build() throws -> URLRequest { self }
}

extension URLRequest {
    private var defaultHeaders: [String: String] {
        return [ "accept-language": "en"]
    }
    mutating func setDefaultHeaders() {
        defaultHeaders.forEach { setValue($0.value, forHTTPHeaderField: $0.key) }
    }
    
    mutating func setAdditional(headers: [String: String]?) {
        headers?.forEach { setValue($0.value, forHTTPHeaderField: $0.key) }
    }
}
