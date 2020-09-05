//
//  ServiceProtocol.swift
//  AxiomTelecom
//
//  Created by Sanu Sathyaseelan on 04/09/2020.
//  Copyright © 2020 Sanu. All rights reserved.
//

import Foundation

protocol ServiceProtocol {
    func request<T: Decodable>(wrapper: ServiceWrapper, completion: @escaping GenericClosure<AXResult<T>>)
    func cancel()
}

enum AXResult<T> {
    case success(T)
    case failure(AXError)
}
