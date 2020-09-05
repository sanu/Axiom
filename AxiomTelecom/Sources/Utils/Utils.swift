//
//  Utils.swift
//  AxiomTelecom
//
//  Created by Sanu Sathyaseelan on 04/09/2020.
//  Copyright © 2020 Sanu. All rights reserved.
//

import Foundation

typealias VoidClosure = () -> Void
typealias GenericClosure<T> = (T) -> Void
typealias GenericResultClosure<T> = GenericClosure<AXResult<T>>
