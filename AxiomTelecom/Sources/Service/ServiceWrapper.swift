//
//  ServiceWrapper.swift
//  ENBDVirtualPrepaidCreditCard
//
//  Created by Abdulla Kunhi on 02/02/20.
//  Copyright © 2019 Solutions 4 Mobility. All rights reserved.
//

import Foundation
import ENBDVirtualPrepaidCreditCardServices

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
    
    var customJsonParams: Any? { serviceModule.customJsonParams }
}
