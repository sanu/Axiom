//
//  ServiceProtocol.swift
//  ENBDVirtualPrepaidCreditCard
//
//  Created by Abdulla Kunhi on 02/02/20.
//  Copyright © 2019 Solutions 4 Mobility. All rights reserved.
//

import Foundation

protocol ServiceProtocol {
    func request<T: Decodable>(wrapper: ServiceWrapper, completion: @escaping GenericClosure<ENBDResult<T>>)
    func upload<T: Decodable>(wrapper: ServiceWrapper, progress: GenericClosure<Double>?, completion: @escaping GenericClosure<ENBDResult<T>>)
    func stopAllTasks()
}

protocol ServiceAuthUpdatable {
    func updateAccessToken(token: UserToken?)
    func clearAccessToken()
}

struct UserToken {
    var accessToken: String?
    var refreshToken: String?
}
