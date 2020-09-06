//
//  UIAlertControllerExtensions.swift
//  AxiomTelecom
//
//  Created by Sanu Sathyaseelan on 06/09/2020.
//  Copyright © 2020 Sanu. All rights reserved.
//

import UIKit

extension UIAlertController {
    // shows alert with ok button
    static func ok(title: String = "", message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.rootViewController?.present(alert, animated: true)
    }
}
