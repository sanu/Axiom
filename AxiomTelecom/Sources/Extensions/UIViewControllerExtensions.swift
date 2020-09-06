//
//  UIViewControllerExtensions.swift
//  AxiomTelecom
//
//  Created by Sanu Sathyaseelan on 06/09/2020.
//  Copyright © 2020 Sanu. All rights reserved.
//

import UIKit

extension UIViewController {
    func addRightBarButton(title: String? = "", image: UIImage? = nil, style: UIBarButtonItem.Style, doneHandler: VoidClosure? = nil) {
        navigationItem.rightBarButtonItem = BarButtonItem(style: style, title: title, image: image, doneHandler: doneHandler)
    }
}
