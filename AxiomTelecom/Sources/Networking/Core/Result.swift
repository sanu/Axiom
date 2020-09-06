//
//  Result.swift
//  AxiomTelecom
//
//  Created by Sanu Sathyaseelan on 06/09/2020.
//  Copyright © 2020 Sanu. All rights reserved.
//

import Foundation

enum Result<String> {
    case success
    case failure(String)
}


struct ErrorResponse: Decodable {
    let message: String?
    let success: Bool?
}
