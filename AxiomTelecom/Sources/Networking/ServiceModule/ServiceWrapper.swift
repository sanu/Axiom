//
//  ServiceWrapper.swift
//  AxiomTelecom
//
//  Created by Sanu Sathyaseelan on 04/09/2020.
//  Copyright © 2020 Sanu. All rights reserved.
//

import Foundation

class ServiceWrapper {
    
    private (set) var serviceModule: ServiceModule
    
    var cachePolicy: URLRequest.CachePolicy {
        return URLRequest.CachePolicy.useProtocolCachePolicy
    }
    
    init(module: ServiceModule) {
        serviceModule = module
    }
}

extension ServiceWrapper {
    
    var defaultParameters: Parameters? { nil }
    
    var parameters: Parameters? {
        serviceModule.parameters
    }
    
    var method: RequestMethod {
        serviceModule.method
    }
    
    var url: URL? {
        serviceModule.url(baseUrl: Configuration.current.baseURL)
    }
    
    var contentType: ContentType { serviceModule.contentType }
    
    var headers: Headers? { serviceModule.additionalHeaders }
}
