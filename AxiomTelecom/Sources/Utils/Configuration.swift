//
//  Configuration.swift
//  AxiomTelecom
//
//  Created by Sanu Sathyaseelan on 04/09/2020.
//  Copyright © 2020 Sanu. All rights reserved.
//

import Foundation

final class Configuration {
    
    static let current = Configuration()
    
    private var all = Parameters()

    private var environment: Environment {
        
        guard let environment = Environment.attributes.decode(Environment.self) else {
            fatalError("Add Environment to your configuration file")
        }
        return environment
    }
    
    lazy var baseURL: URL? = createBaseURL()
    
    private init() {
        all = Bundle.main.infoDictionary?["Configuration"] as? Parameters ?? [:]
    }
}

private extension Configuration {
    
    func createBaseURL() -> URL? {
        
        guard let host = Configuration.current.environment.host, let protocolString = Configuration.current.environment.protocolString else {
            fatalError("Add host and protocol to your configuration file")
        }
        
        var urlComponents = URLComponents()
        urlComponents.scheme = protocolString
        urlComponents.host = host

        let url = urlComponents.url
        return url
    }
}

private extension Configuration {
    
    struct Environment: Decodable {
        
        var protocolString: String?
        var host: String?
        
        static var attributes: Parameters {
            return Configuration.current.all["Environment"] as? Parameters ?? [:]
        }
        
        private enum CodingKeys: String, CodingKey {
            case protocolString = "Protocol"
            case host = "Host"
        }
    }
}
