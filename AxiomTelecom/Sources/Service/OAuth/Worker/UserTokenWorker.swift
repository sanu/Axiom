//
//  UserTokenWorker.swift
//  ENBDVirtualPrepaidCreditCard
//
//  Created by Abdulla Kunhi on 06/07/2020.
//  Copyright © 2020 Solutions 4 Mobility. All rights reserved.
//

import Foundation
import ENBDVirtualPrepaidCreditCardServices

protocol UserTokenDataProvider {
    func refreshTokenForPostLoginUser(refreshToken: String, completion: GenericResultClosure<Void>?)
    func refreshTokenForPreLoginUser(completion: @escaping GenericResultClosure<OAuthTokenResponse>)
}

class UserTokenWorker: UserTokenDataProvider {
    
    var serviceManager: ServiceProtocol & ServiceAuthUpdatable
    
    init() {
        serviceManager = ServiceManager.shared
    }
    
    func refreshTokenForPostLoginUser(refreshToken: String, completion: GenericResultClosure<Void>?) {
        serviceManager.request(wrapper: ServiceWrapper(module: SecurityModule.refreshUserToken(refreshToken: refreshToken))) { [weak self] (result: ENBDResult<PostLoginOAuthTokenResponse>) in
            switch result {
            case .success(let response):
                // save access token into keychain for capture source card details and to load other payment WebView
                KeychainManager.shared.postLoginAccessToken = response.tokenResponse?.accessToken
                // save refresh token into keychain for logout from the app
                KeychainManager.shared.refreshToken = response.tokenResponse?.refreshToken
                
                // update access token in OAuthHandler
                self?.serviceManager.updateAccessToken(token: UserToken(accessToken: response.tokenResponse?.accessToken, refreshToken: response.tokenResponse?.refreshToken))
                
                completion?(.success(()))
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
    
    func refreshTokenForPreLoginUser(completion: @escaping GenericResultClosure<OAuthTokenResponse>) {
        serviceManager.request(wrapper: ServiceWrapper(module: SecurityModule.getAccessToken)) { (result: ENBDResult<OAuthTokenResponse>) in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

public enum SecurityModule: ServiceModule {
    
    case getAccessToken
    case refreshUserToken(refreshToken: String)
    case generateSmartLoginOtp(loginType: Int)
    case generateKeys(parameters: Parameters)
    case registerSmartLogin(parameters: Parameters)
    case getServerDateAndTime
    case disableSmartLogin(parameters: Parameters)
    
    public var method: RequestMethod {
        switch self {
        case .getServerDateAndTime: return .get
        default: return .post
        }
    }
    
    public var section: Section? { .sec }
    
    public var module: Module? { .security }
    
    public var path: Path? {
        switch self {
        case .getAccessToken: return .getAccessToken
        case .refreshUserToken: return .refreshUserToken
        case .generateSmartLoginOtp: return .generateSmartLoginOtp
        case .generateKeys: return .generateKeys
        case .registerSmartLogin: return .registerSmartLogin
        case .getServerDateAndTime: return .getServerDateAndTime
        case .disableSmartLogin: return .disableSmartLogin
        }
    }
    
    public var parameters: Parameters? {
        switch self {
        case .getAccessToken, .getServerDateAndTime: return nil
        case .refreshUserToken(let token): return ["refreshToken": token]
        case .generateSmartLoginOtp(let loginType): return ["loginType": loginType]
        case .generateKeys(let parameters): return parameters
        case .registerSmartLogin(let parameters), .disableSmartLogin(let parameters): return parameters
        }
    }
    
}
