//
//  LoadingView.swift
//  AxiomTelecom
//
//  Created by Sanu Sathyaseelan on 06/09/2020.
//  Copyright © 2020 Sanu. All rights reserved.
//

import UIKit

class LoadingView: UIView {

    static private let sharedLoadingIndicatorView = LoadingView(frame: UIScreen.main.bounds)
    
    private lazy var animatingView = createAnimatingView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    func configure() {
        addSubview(animatingView)
        animatingView.centerAlign()
    }
    
    private func createAnimatingView() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.color = .red
        return activityIndicator
    }
}

private extension LoadingView {
    
    func startAnimating() {
        animatingView.startAnimating()
    }
    
    func stopAnimating() {
        animatingView.stopAnimating()
    }
}

extension LoadingView {
    
    static func show() {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else { return }
            window.endEditing(true)
            window.addSubview(sharedLoadingIndicatorView)
            sharedLoadingIndicatorView.alpha = 1.0
            sharedLoadingIndicatorView.fillInSuperView()
            sharedLoadingIndicatorView.transform = CGAffineTransform(scaleX: 0.65, y: 0.65)
            sharedLoadingIndicatorView.startAnimating()
        }
    }
    
    static func dismiss() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.05, animations: {
                sharedLoadingIndicatorView.alpha = 0.0
                sharedLoadingIndicatorView.transform = CGAffineTransform(scaleX: 0.65, y: 0.65)
            }, completion: { _ in
                sharedLoadingIndicatorView.stopAnimating()
                sharedLoadingIndicatorView.removeFromSuperview()
            })
        }
    }
}

protocol LoadingDismissible {
    func dismissLoading()
}

extension LoadingDismissible where Self: UIViewController {
    func dismissLoading() {
        LoadingView.dismiss()
    }
}
