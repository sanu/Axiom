//
//  CatalogCollectionViewCell.swift
//  AxiomTelecom
//
//  Created by Sanu Sathyaseelan on 06/09/2020.
//  Copyright © 2020 Sanu. All rights reserved.
//

import UIKit

class CatalogCollectionViewCell: UICollectionViewCell {
    
    var mobile: Mobile? {
        didSet {
            configureView()
        }
    }
    
    @IBOutlet weak var labelModelName: UILabel?
    @IBOutlet weak var labelPrice: UILabel?
    @IBOutlet weak var imageViewModel: UIImageView?
    
    func configureView() {
        guard let mobile = mobile else { return }
        labelModelName?.text = mobile.model
        labelPrice?.text = mobile.price
        imageViewModel?.imageFromURL(url: mobile.url)
    }
}
