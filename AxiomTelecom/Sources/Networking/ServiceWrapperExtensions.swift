//
//  ServiceWrapperExtensions.swift
//  AxiomTelecom
//
//  Created by Sanu Sathyaseelan on 06/09/2020.
//  Copyright © 2020 Sanu. All rights reserved.
//

import Foundation

extension ServiceWrapper: URLRequestBuilder {
    func build() throws -> URLRequest {
        
        var urlRequest = URLRequest(url: qualifiedUrl, cachePolicy: .useProtocolCachePolicy)
        urlRequest.httpMethod = method.rawValue
        
        urlRequest.setDefaultHeaders()
        urlRequest.setAdditional(headers: headers)
        
        var requestParams = parameters
        if let defaultParameters = defaultParameters {
            requestParams = defaultParameters.merging(parameters ?? [:]) { _, custom in custom }
        }
        
        switch contentType {
        case .jsonEncoded:
            return try JSONEncoding.default.encode(urlRequest: urlRequest, with: requestParams)
        case .urlEncoded:
            return try URLEncoding.default.encode(urlRequest: urlRequest, with: requestParams)
        }
    }
}

extension ServiceWrapper {
    var qualifiedUrl: URL {
        return url ?? URL(fileURLWithPath: url?.absoluteString ?? "")
    }
}
