//
//  UIViewExtensions.swift
//  AxiomTelecom
//
//  Created by Sanu Sathyaseelan on 06/09/2020.
//  Copyright © 2020 Sanu. All rights reserved.
//

import UIKit

extension UIView {
    
    // instantiate view from nib
    class func instantiateFromNib<T: UIView>() -> T? {
        return nib.instantiate(withOwner: nil, options: nil).first as? T
    }
    
    // get nib from bundle
    class var nib: UINib {
        return UINib(nibName: nibName, bundle: nil)
    }
    
    // get nib name
    class var nibName: String {
        return identifier
    }
}

extension UIView {
    
    // autolayout to fill view
    func fillInSuperView(top: CGFloat = 0.0, bottom: CGFloat = 0.0, leading: CGFloat = 0.0, trailing: CGFloat = 0.0) {
        
        // add basic layout constraints for the view
        guard let superview = superview else { return }
        
        translatesAutoresizingMaskIntoConstraints = false
        
        superview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(leading)-[view]-\(trailing)-|", options: [], metrics: nil, views: ["view": self]))
        superview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-\(top)-[view]-\(bottom)-|", options: [], metrics: nil, views: ["view": self]))
    }
}

extension UIView {
    
    var safeLeft: NSLayoutXAxisAnchor {
        return safeAreaLayoutGuide.leadingAnchor
    }
    
    var safeRight: NSLayoutXAxisAnchor {
        return safeAreaLayoutGuide.trailingAnchor
    }
    
    var safeTop: NSLayoutYAxisAnchor {
        return safeAreaLayoutGuide.topAnchor
    }
    
    var safeBottom: NSLayoutYAxisAnchor {
        return safeAreaLayoutGuide.bottomAnchor
    }
    
    func fill(leading: NSLayoutXAxisAnchor? = nil, trailing: NSLayoutXAxisAnchor? = nil, top: NSLayoutYAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, insets: UIEdgeInsets = .zero) {
        
        translatesAutoresizingMaskIntoConstraints = false
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: insets.left).isActive = true
        }
        
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: -insets.right).isActive = true
        }
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: insets.top).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -insets.bottom).isActive = true
        }
    }
}
