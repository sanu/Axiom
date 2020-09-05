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
            
            if let response = response as? HTTPURLResponse {
                let result = self?.handleNetworkResponse(response)
                
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(.failure(AXError.unknownError))
                        return
                    }
                    do {
                        let model = try JSONDecoder().decode(T.self, from: responseData)
                        completion(.success(model))
                    }catch {
                        completion(.failure(AXError.unknownError))
                    }
                case .failure(_):
                    completion(.failure(AXError.unknownError))
                default: break
                }
            }
        }
    }
}




