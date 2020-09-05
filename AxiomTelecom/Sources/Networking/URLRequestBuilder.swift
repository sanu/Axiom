//
//  URLRequestBuilder.swift
//  AxiomTelecom
//
//  Created by Sanu Sathyaseelan on 06/09/2020.
//  Copyright © 2020 Sanu. All rights reserved.
//

import Foundation

protocol URLRequestBuilder {
    func build() throws -> URLRequest
}

extension URLRequestBuilder {
    var urlRequest: URLRequest? { try? build() }
}
