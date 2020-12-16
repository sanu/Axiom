//
//  OAuthHandler.swift
//  ENBDVirtualPrepaidCreditCard
//
//  Created by Lincy Francis on 13/04/2020.
//  Copyright © 2020 Solutions 4 Mobility. All rights reserved.
//

import Foundation
import Alamofire
import ENBDVirtualPrepaidCreditCardServices

class OAuthHandler: RequestInterceptor {
    
    var isRefreshing = false
    
    var preLoginAccessToken: String?
    var postLoginAccessToken: String?
    var postLoginRefreshToken: String?
    
    private var error: Error?
    
    private let retriesCount = 2
    
    // lock
    private let lock = NSLock()
    
    private var worker: UserTokenDataProvider?
    
    init(worker: UserTokenDataProvider = UserTokenWorker()) {
        self.worker = worker
    }
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        
        // set all default headers
        var request = urlRequest
        
        if request.url?.isAuthUrl ?? false {
            let obfuscator = Obfuscator()
            let authHeader = HTTPHeader.authorization(username: obfuscator.clientId, password: obfuscator.clientSecret)
            request.headers.add(authHeader)
            return completion(.success(request))
        }
        
        if let token = postLoginAccessToken ?? preLoginAccessToken {
            let authHeader = HTTPHeader.authorization(bearerToken: token)
            request.headers.add(authHeader)
            return completion(.success(request))
        }
        
        completion(.success(request))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        lock.lock()
        
        defer {
            lock.unlock()
        }
        
        guard let request = request as? DataRequest, let data = request.data, let statusCode = request.response?.statusCode, statusCode == 401 else {
            completion(.doNotRetry)
            return
        }
        
        let vpccError = data.wrapToVPCCError(statusCode: statusCode)
        
        print("Service Repsonse :- " + (String(data: data, encoding: .utf8) ?? ""))
        guard vpccError.isInvalidToken else {
            completion(.doNotRetry)
            return
        }
        handleRetryRequest(request: request, error: vpccError, completion: completion)
    }
}

private extension OAuthHandler {
    
    func handleRetryRequest(request: DataRequest, error: VPCCError, completion: @escaping (RetryResult) -> Void) {
        guard !isRefreshing else { return }
        refreshToken { [weak self] (result) in
            guard let weakSelf = self else { return }
            
            weakSelf.lock.lock()
            defer {
                weakSelf.lock.unlock()
            }
            
            weakSelf.isRefreshing = false
            
            switch result {
            case .success:
                completion(.retry)
            case .failure(let newError):
                guard newError.shouldUpgradeApp else {
                    completion(request.retryCount >= weakSelf.retriesCount ? .doNotRetryWithError(error) : .retry)
                    return
                }
                completion(.doNotRetryWithError(newError))
            }
        }
    }
    
    func refreshToken(completion: @escaping GenericResultClosure<Void>) {
        guard !isRefreshing else { return }
        isRefreshing = true
        
        if let postLoginRefreshToken = postLoginRefreshToken {
            refreshTokenForPostLoginUser(refreshToken: postLoginRefreshToken, completion: completion)
        } else {
            refreshTokenForPreLoginUser(completion: completion)
        }
    }
    
    func refreshTokenForPreLoginUser(completion: @escaping GenericResultClosure<Void>) {
        worker?.refreshTokenForPreLoginUser(completion: { [weak self] result in
            switch result {
            case .success(let response):
                self?.preLoginAccessToken = response.accessToken
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
    func refreshTokenForPostLoginUser(refreshToken: String, completion: @escaping GenericResultClosure<Void>) {
        worker?.refreshTokenForPostLoginUser(refreshToken: refreshToken) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

private extension URL {
    var isAuthUrl: Bool {
        let isAccesstokenUrl = SecurityModule.getAccessToken.url(baseUrl: Configuration.current.baseURL)?.absoluteString == absoluteString
        let isRefreshTokenUrl = SecurityModule.refreshUserToken(refreshToken: "").url(baseUrl: Configuration.current.baseURL)?.absoluteString == absoluteString
        return isAccesstokenUrl || isRefreshTokenUrl
    }
}
