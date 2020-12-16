//
//  URLRequest-Headers.swift
//  ENBDVirtualPrepaidCreditCard
//
//  Created by Lincy Francis on 13/04/2020.
//  Copyright © 2020 Solutions 4 Mobility. All rights reserved.
//

import UIKit
import FTLocalizationManager

extension URLRequest {
    var defaultHeaders: [String: String] {
        return [
            "accept-language": language,
            "Device-Id": UIDevice.deviceId,
            "Correlation-id": UIDevice.corelationId,
            "User-Agent": userAgent
        ]
    }
    mutating func setDefaultHeaders() {
        defaultHeaders.forEach { setValue($0.value, forHTTPHeaderField: $0.key) }
        
    }
    
    mutating func setAdditional(headers: [String: String]?) {
        headers?.forEach { setValue($0.value, forHTTPHeaderField: $0.key) }
    }
}

private extension URLRequest {
    
    private var language: String { Language.current.locale }
    
    var userAgent: String {
        if let info = Bundle.main.infoDictionary {
            let executable = "joyn"
            let appVersion = info["CFBundleShortVersionString"] as? String ?? "Unknown"
            let buildNumber = info[String(kCFBundleVersionKey)] as? String ?? "Unknown"
            
            let osNameVersion: String = {
                let version = ProcessInfo.processInfo.operatingSystemVersion
                let versionString = "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"
                
                return "iOS \(versionString)"
            }()
            
            return "\(executable)/\(appVersion) (build: \(buildNumber); mobile: iPhone; os: \(osNameVersion))"
        }
        
        return "Alamofire"
    }
}
