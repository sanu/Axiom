//
//  UIImageViewExtensions.swift
//  AxiomTelecom
//
//  Created by Sanu Sathyaseelan on 06/09/2020.
//  Copyright © 2020 Sanu. All rights reserved.
//

import UIKit

extension UIImageView {
    
    // downloads image from the passed url and displays it in imageView
    public func imageFromURL(url: URL?) {
        
        guard let url = url else { return }

        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.frame = CGRect.init(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        activityIndicator.startAnimating()
        if image == nil {
            addSubview(activityIndicator)
        }
        
        ServiceManager.shared.downloadImage(from: url) { [weak self] data in
            DispatchQueue.main.async { [weak self] in
                guard let data = data else { return }
                activityIndicator.removeFromSuperview()
                let image = UIImage(data: data)
                self?.image = image
            }
        }
    }
}
