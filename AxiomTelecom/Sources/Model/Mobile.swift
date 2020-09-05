//
//  Mobile.swift
//  AxiomTelecom
//
//  Created by Sanu Sathyaseelan on 06/09/2020.
//  Copyright © 2020 Sanu. All rights reserved.
//

import Foundation

struct Mobile {
    
    private static let serviceManager: ServiceProtocol = ServiceManager.shared
    
    let brand: String
    let price: String
    let model: String?
    let url: URL?
}

extension Mobile {
    static func completeBrands(products: [Mobile]) -> [String] {
        return products.map{$0.brand}.unique()
    }
}

extension Mobile {
    static func loadCatalogs(onSuccess: @escaping GenericClosure<[Mobile]>, onFailure: @escaping GenericClosure<AXError>) {
        serviceManager.request(wrapper: ServiceWrapper(module: CatalogModule.getLatest)) { (result: AXResult<[MobileAPIResponse]>) in
            switch result {
            case .success(let response):
                let mappedObjects = response.map { MobileAPIResponse.map($0) }
                onSuccess(mappedObjects)
            case .failure(let error):
                onFailure(error)
            }
        }
    }
}

private struct MobileAPIResponse: Decodable {
    let id: Int?
    let brand: String?
    let phone: String?
    let picture: String?
    let sim: String?
    let resolution: String?
    let audioJack: String?
    let gps: String?
    let battery: String?
    let priceEur: Int?
}

private extension MobileAPIResponse {
    
    private var displayPrice: String {
        guard let price = priceEur else { return "" }
        return "$\(price)"
    }
    
    private var url: URL? {
        guard let picture = picture else { return nil }
        return URL(string: picture)
    }
    
    static func map(_ dto: MobileAPIResponse) -> Mobile {
        return Mobile(brand: dto.brand ?? "", price: dto.displayPrice, model: dto.phone, url: dto.url)
    }
}
