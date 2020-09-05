//
//  DequeReusable.swift
//  AxiomTelecom
//
//  Created by Sanu Sathyaseelan on 06/09/2020.
//  Copyright © 2020 Sanu. All rights reserved.
//

import UIKit

protocol DequeueReusable {
    static func dequeueReusableCell(in view: UIView, indexPath: IndexPath) -> Self
}


extension UITableViewCell: DequeueReusable { }

extension DequeueReusable where Self: UITableViewCell {
    
    static func dequeueReusableCell(in view: UIView, indexPath: IndexPath) -> Self {
        
        guard let tableView = view as? UITableView, let cell = tableView.dequeueReusableCell(withIdentifier: Self.identifier, for: indexPath) as? Self else { return Self() }
        return cell
    }
}

extension UICollectionViewCell: DequeueReusable { }

extension DequeueReusable where Self: UICollectionViewCell {
    
    static func dequeueReusableCell(in view: UIView, indexPath: IndexPath) -> Self {
        
        guard let collectionView = view as? UICollectionView, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Self.identifier, for: indexPath) as? Self else { return Self() }
        return cell
    }
}

protocol Identifiable {
    static var identifier: String { get }
}

extension UIResponder: Identifiable {
    
    static var identifier: String {
        return "\(self)"
    }
}
