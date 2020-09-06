//
//  ServiceModule.swift
//  AxiomTelecom
//
//  Created by Sanu Sathyaseelan on 04/09/2020.
//  Copyright © 2020 Sanu. All rights reserved.
//

import Foundation

public typealias Parameters = [String: Any]
public typealias Headers = [String: String]

public enum ContentType {
    case jsonEncoded
    case urlEncoded
}

public protocol ServiceModule {
    var method: RequestMethod { get }
    var parameters: Parameters? { get }
    var module: Module? { get }
    var path: Path? { get }
    var subPath: SubPath? { get }
    var contentType: ContentType { get }
    var additionalHeaders: Headers? { get }
    func url(baseUrl: URL?) -> URL?
}

public extension ServiceModule {
    
    func url(baseUrl: URL?) -> URL? {
        
        var url = baseUrl
        
        if let module = module {
            url?.appendPathComponent("/\(module.rawValue)")
        }
        
        if let path = path {
            url?.appendPathComponent("/\(path.rawValue)")
        }
        
        if let subPath = subPath {
            url?.appendPathComponent("/\(subPath.rawValue)")
        }
        return url
    }
}

public extension ServiceModule {
    var method: RequestMethod { .get }
    var parameters: Parameters? { nil }
    var module: Module? { .bin }
    var path: Path? { .binId }
    var subPath: SubPath? { nil }
    var contentType: ContentType { .jsonEncoded }
    var additionalHeaders: Headers? { secretHeader }
}

public enum RequestMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

public enum Module: String {
    case bin = "b"
}

public enum Path: String {
    case binId = "5f3a3fcf4d939910361666fe"
}

public enum SubPath: String {
    case latest =  "latest"
}

private let secretHeader = ["secret-key": Obfuscator.shared.secretKey]
