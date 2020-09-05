//
//  CatalogModule.swift
//  AxiomTelecom
//
//  Created by Sanu Sathyaseelan on 04/09/2020.
//  Copyright © 2020 Sanu. All rights reserved.
//

import Foundation

public enum CatalogModule: ServiceModule {
    
    case getLatest
    
    public var method: RequestMethod {
        .get
    }
    
    public var subPath: SubPath? {
        .latest
    }
}
