//
//  ServiceManager.swift
//  ENBDVirtualPrepaidCreditCard
//
//  Created by Sanu Sathyaseelan on 04/11/2019.
//  Copyright © 2019 Solutions 4 Mobility. All rights reserved.
//

import Foundation
import Alamofire

class ServiceManager {
 
    static let shared = ServiceManager()
    
    private lazy var manager: Session = {
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = 120.0
        let session = Session(configuration: configuration, interceptor: OAuthHandler())
        return session
    }()

    private init() {
        // Restricting Service manager initialisation other than shared access.
    }
    
    func request<T: Decodable>(request: URLRequest, completion: @escaping GenericClosure<ENBDResult<T>>) {
        print(request)
        manager.request(request).validate().responseDecodable(emptyResponseCodes: [200, 204, 205]) { [weak self] (response: AFDataResponse<T>) in
            self?.decode(response: response, completion: completion)
        }
    }
    
    func upload<T: Decodable>(request: URLRequestConvertible, multipartFormData: @escaping (MultipartFormData) -> Void, progressUpdate: GenericClosure<Double>?, completion: @escaping GenericClosure<ENBDResult<T>>) {
        print(request)
        let uploadRequest = manager.upload(multipartFormData: multipartFormData, with: request)
        uploadRequest.uploadProgress { progress in
            progressUpdate?(progress.fractionCompleted)
        }
        uploadRequest.validate().responseDecodable { [weak self] (response: AFDataResponse<T>) in
            self?.decode(response: response, completion: completion)
        }
    }
}

private extension ServiceManager {
    func decode<T: Decodable>(response: AFDataResponse<T>, completion: @escaping GenericClosure<ENBDResult<T>>) {
        
        print(response.request?.allHTTPHeaderFields ?? [:])
        print(response)
        
        let data = response.data
        let statusCode = response.response?.statusCode ?? 0
        
        switch response.result {
        case .success(let result):
            GlobalSession.shared.refreshSession()
            completion(.success(result))
        case .failure(let error):
            
            let error = wrapVPCCError(error: error, data: data, statusCode: statusCode)
            
            // for throwable error, do not pass completion to avoid multiple error pop ups
            if error.isThrowableError { return }
            
            completion(.failure(error))
        }
    }
}

private extension ServiceManager {
    private func wrapVPCCError(error: AFError, data: Data?, statusCode: Int) -> VPCCError {
        
        if let underlyingError = error.underlyingError as? URLError {
            if underlyingError.code != URLError.notConnectedToInternet {
                GlobalSession.shared.refreshSession()
            }
            return VPCCError(key: VPCCError.Keys.urlError, message: underlyingError.localizedDescription)
        }

        if let uabError = error.underlyingError as? VPCCError {
            return uabError
        }
        
        if let decodingError = error.underlyingError as? DecodingError {
            return decodingError.vpccError
        }
        
        return data?.wrapToVPCCError(statusCode: statusCode) ?? VPCCError.unknownError
    }
}

extension ServiceManager: ServiceProtocol {
    
    func request<T: Decodable>(wrapper: ServiceWrapper, completion: @escaping GenericClosure<ENBDResult<T>>) {
        guard let serviceRequest = wrapper.urlRequest else { return }
        request(request: serviceRequest, completion: completion)
    }
}

extension ServiceManager {
    func upload<T: Decodable>(wrapper: ServiceWrapper, progress: GenericClosure<Double>? = nil, completion: @escaping (ENBDResult<T>) -> Void) {
        
        upload(request: wrapper, multipartFormData: { multipartFormData in
            guard let parameters = wrapper.parameters else { return }
            
            for (key, value) in parameters {
                if let image = value as? UIImage, let imageData = image.compress() {
                    multipartFormData.append(imageData, withName: key, fileName: key+".jpg", mimeType: "image/jpeg")
                } else if let url = value as? URL {
                    self.handleUrl(url: url, key: key, multipartFormData: multipartFormData)
                } else if let intValue = value as? Int, let formData = "\(intValue)".data(using: String.Encoding.utf8) {
                    multipartFormData.append(formData, withName: key)
                } else if let intValue = value as? Double, let formData = "\(intValue)".data(using: String.Encoding.utf8) {
                    multipartFormData.append(formData, withName: key)
                } else if let data = (value as AnyObject).data?(using: String.Encoding.utf8.rawValue) {
                    multipartFormData.append(data, withName: key)
                } else {
                    // no actions
                }
            }
        }, progressUpdate: progress, completion: completion)
    }
}

extension ServiceWrapper: URLRequestConvertible {
    func asURLRequest() throws -> URLRequest {
        
        var requestParams = parameters
        if let defaultParameters = defaultParameters {
            requestParams = defaultParameters.merging(parameters ?? [:]) { _, custom in custom }
        }
        
        var urlRequest = try URLRequest(url: qualifiedUrl, method: HTTPMethod(rawValue: method.rawValue))
        
        urlRequest.setDefaultHeaders()
        urlRequest.setAdditional(headers: headers)
        
        urlRequest.cachePolicy = cachePolicy
        
        switch contentType {
        case .jsonEncoded:
            return try Alamofire.JSONEncoding.default.encode(urlRequest, with: requestParams)
        case .urlEncoded:
            return try Alamofire.URLEncoding.default.encode(urlRequest, with: requestParams)
        case .jsonCompatibleAnyObject:
            return try Alamofire.JSONEncoding.default.encode(urlRequest, withJSONObject: customJsonParams)
        }
    }
}

extension ServiceWrapper {
    var qualifiedUrl: URL {
        return url ?? URL(fileURLWithPath: url?.absoluteString ?? "")
    }
}

extension ServiceManager: ServiceAuthUpdatable {
    func updateAccessToken(token: UserToken?) {
        (manager.interceptor as? OAuthHandler)?.postLoginAccessToken = token?.accessToken
        (manager.interceptor as? OAuthHandler)?.postLoginRefreshToken = token?.refreshToken
    }
    
    func clearAccessToken() {
        updateAccessToken(token: nil)
    }
}

extension ServiceManager {
    func stopAllTasks() {
        manager.session.getAllTasks {
            $0.forEach {  $0.cancel() }
        }
    }
    
    func killSession() {
        stopAllTasks()
        clearAccessToken()
        (manager.interceptor as? OAuthHandler)?.preLoginAccessToken = nil
    }
}

extension ServiceManager {
    private func handleUrl(url: URL, key: String, multipartFormData: MultipartFormData) {
          
          if url.pathExtension == "jpeg" {
              if let image = UIImage(contentsOfFile: url.path), let imageData = image.jpegData(compressionQuality: 0.001) {
                  multipartFormData.append(imageData, withName: key, fileName: key+".jpg", mimeType: "image/jpeg")
              }
          } else {
              if let data = try? Data(contentsOf: url) {
                  multipartFormData.append(data, withName: key, fileName: key+".json", mimeType: "application/json")
              }
          }
      }
}

// all Service response models which can expect response should conform to this EmptyResponseDecodable protocol
protocol EmptyResponseDecodable: EmptyResponse {}

private extension VPCCError {
    var isThrowableError: Bool {
        
        if shouldUpgradeApp {
            // show the force upgrade error & cancel all services
            return true
        }
        
        if isSessionExpired || isSessionOverriden, AppSession.current.sessionExists {
            ServiceManager.shared.killSession()
            message = &&"msg_session_timeout"
            AppSession.current.logout(mode: .error(self))
            return true
        }
        return false
    }
}

extension VPCCError {
    
    var isInvalidToken: Bool { key == Keys.invalidToken }
}

extension VPCCError {
    
    struct Keys {
        static let urlError = "url_error"
        static let jsonParsing = "json_parsing_error"
}
}

extension VPCCError {
    
    enum ErrorMode {
        case emailNotVerified
        case securityQuestionNotConfigured
        case maxResendOtpAttemptsExceeded
        case maxInvalidOtpAttemptsExceeded
        case securityAnswersMaxInvalidAttemptsExceeded
        case maxInvalidMpinAttemptsExceeded
        case normal
        case htmlError
        case incorrectOtp
        case mpinAlreadyConfiguredOnOtherDevice
    }
    
    var mode: ErrorMode {
        
        if isEmailNotVerified {
            return .emailNotVerified
        }
        
        if isSecurityQuestionNotConfigured {
            return .securityQuestionNotConfigured
        }
        
        if isMaxResendOtpAttemptsExceeded {
            return .maxResendOtpAttemptsExceeded
        }
        
        if isMaxInvalidOtpAttemptsExceeded {
            return .maxInvalidOtpAttemptsExceeded
        }
        
        if isSecurityAnswersMaxInvalidAttemptsExceeded {
            return .securityAnswersMaxInvalidAttemptsExceeded
        }
        
        if isMaxInvalidMpinAttemptsExceeded {
            return .maxInvalidMpinAttemptsExceeded
        }
        
        if isHTMLError {
            return .htmlError
        }
        
        if isIncorrectOtp {
            return .incorrectOtp
        }
        
        if isMpinAlreadyConfiguredOnOtherDevice {
            return .mpinAlreadyConfiguredOnOtherDevice
        }
        
        return .normal
    }
}
