//
//  UICollectionViewExtensions.swift
//  AxiomTelecom
//
//  Created by Sanu Sathyaseelan on 06/09/2020.
//  Copyright © 2020 Sanu. All rights reserved.
//

import UIKit

extension UICollectionView {
    func register<T: UICollectionViewCell>(_ : T.Type) {
        register(T.self, forCellWithReuseIdentifier: T.identifier)
    }
    func registerNib<T: UICollectionViewCell>(_ : T.Type) {
        register(T.nib, forCellWithReuseIdentifier: T.identifier)
    }
}
