//
//  OAuthTokenResponse.swift
//  ENBDVirtualPrepaidCreditCard
//
//  Created by Lincy Francis on 14/04/2020.
//  Copyright © 2020 Solutions 4 Mobility. All rights reserved.
//

import Foundation

struct OAuthTokenResponse: Decodable {
    let accessToken: String?
    let tokenType: String?
    let expiresIn: Int?
    let refreshToken: String?
}

struct PostLoginOAuthTokenResponse: Decodable {
    let tokenResponse: OAuthTokenResponse?
}
