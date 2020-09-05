//
//  Encoder.swift
//  AxiomTelecom
//
//  Created by Sanu Sathyaseelan on 06/09/2020.
//  Copyright © 2020 Sanu. All rights reserved.
//

import Foundation

protocol ParameterEncoding {
    func encode(urlRequest: URLRequestBuilder, with parameters: Parameters?) throws -> URLRequest
}

class URLEncoding: ParameterEncoding {
    
    static let `default` = URLEncoding()
    
    func encode(urlRequest: URLRequestBuilder, with parameters: Parameters?) throws -> URLRequest {
        
        var urlRequest = try urlRequest.build()
        
        guard let url = urlRequest.url, let parameters = parameters else { return urlRequest }
        
        
        if var urlComponents = URLComponents(url: url,
                                             resolvingAgainstBaseURL: false), !parameters.isEmpty {
            
            urlComponents.queryItems = [URLQueryItem]()
            
            for (key,value) in parameters {
                let queryItem = URLQueryItem(name: key,
                                             value: "\(value)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))
                urlComponents.queryItems?.append(queryItem)
            }
            urlRequest.url = urlComponents.url
        }
        
        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        }
        return urlRequest
    }
}

class JSONEncoding: ParameterEncoding {
    
    static let `default` = JSONEncoding()
    
    func encode(urlRequest: URLRequestBuilder, with parameters: Parameters?) throws -> URLRequest {
        var urlRequest = try urlRequest.build()
        
        guard let parameters = parameters else { return urlRequest }

        do {
            let data = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)

            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }

            urlRequest.httpBody = data
        } catch {
            throw AXError.encodingError
        }
        return urlRequest
    }
}
