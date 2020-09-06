//
//  ServiceManager.swift
//  AxiomTelecom
//
//  Created by Sanu Sathyaseelan on 04/09/2020.
//  Copyright © 2020 Sanu. All rights reserved.
//

import Foundation

final class ServiceManager {
    
    static let shared = ServiceManager()
    private init() {}
    
    private var task: URLSessionTask?
    
    private lazy var manager: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60.0
        let session = URLSession(configuration: configuration)
        return session
    }()
    
    typealias NetworkRouterCompletion = (_ data: Data?,_ response: URLResponse?,_ error: Error?) -> ()
    
    func request(request: URLRequest, completion: @escaping NetworkRouterCompletion) {
        task = manager.dataTask(with: request, completionHandler: { (data, response, error) in
            completion(data, response, error)
        })
        task?.resume()
    }
    
    func cancel() {
        task?.cancel()
    }
    
    func downloadImage(from url: URL, completion: @escaping (Data?) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else { return }
            completion(data)
        }.resume()
    }
}

private extension ServiceManager {
    func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String> {
        switch response.statusCode {
        case 200...299: return .success
        default: return .failure(AXError.keys.unknownError)
        }
    }
}

extension ServiceManager: ServiceProtocol {
    
    func request<T: Decodable>(wrapper: ServiceWrapper, completion: @escaping GenericClosure<AXResult<T>>) {
        guard let serviceRequest = wrapper.urlRequest else { return }
        
        request(request: serviceRequest) { [weak self] (data, response, error) in
            
            // handle error
            guard error == nil else {
                completion(.failure(AXError(key: AXError.keys.commonError, message: error!.localizedDescription)))
                return
            }
            
            if let response = response as? HTTPURLResponse {
                let result = self?.handleNetworkResponse(response)
                guard let responseData = data else {
                    completion(.failure(AXError.unknownError))
                    return
                }
                switch result {
                case .success:
                    do {
                        let model = try JSONDecoder().decode(T.self, from: responseData)
                        completion(.success(model))
                    }catch {
                        completion(.failure(AXError.decodingFailureError))
                    }
                case .failure( _):
                    guard let welf = self  else { return }
                    completion(.failure(welf.wrapError(data: responseData, statusCode: response.statusCode)))
                default: break
                }
            }
        }
    }
}

private extension ServiceManager {
    
    func wrapError(data: Data?, statusCode: Int) -> AXError {
        guard let data = data else { return AXError.encodingError }
        return data.wrapToAXError(statusCode: statusCode)
    }
}

private extension Data {
    
    func wrapToAXError(statusCode: Int) -> AXError {
        
        if let error = serializeError(ErrorResponse.self, code: statusCode) {
            return error
        }
        
        return AXError.unknownError
    }
    
    private func serializeError<T: Decodable>(_ : T.Type, code: Int) -> AXError? {
        guard let errorResponse = try? JSONDecoder().decode(T.self, from: self) else { return nil }
        
        if let response = errorResponse as? ErrorResponse {
            return AXError(code: code, key: "server_error", message: response.message ?? "unknown_error")
        }
        return nil
    }
}
