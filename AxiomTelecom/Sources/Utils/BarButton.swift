//
//  BarButton.swift
//  AxiomTelecom
//
//  Created by Sanu Sathyaseelan on 06/09/2020.
//  Copyright © 2020 Sanu. All rights reserved.
//

import UIKit

final class BarButtonItem: UIBarButtonItem {
    
    private var doneHandler: VoidClosure?
    
    convenience init(style: UIBarButtonItem.Style = .done, title: String? = "", image: UIImage? = nil, doneHandler: VoidClosure? = nil) {
        self.init()
        accessibilityIdentifier = "barButtonItemRight"
        action = #selector(barButtonTapped)
        target = self
       
        self.title = title
        self.style = style
        self.image = image
        self.doneHandler = doneHandler
    }
    
    @objc
    func barButtonTapped() {
        doneHandler?()
    }
}
