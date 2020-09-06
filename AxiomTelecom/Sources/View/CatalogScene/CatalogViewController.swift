//
//  CatalogViewController.swift
//  AxiomTelecom
//
//  Created by Sanu Sathyaseelan on 06/09/2020.
//  Copyright © 2020 Sanu. All rights reserved.
//

import UIKit

class CatalogViewController: UIViewController {
    
    private lazy var catalogcollectionView = createCollectionView()
    private lazy var brandheaderView = BrandView()
    
    private let collectionViewSpacing: CGFloat = 5
    
    private var datasource: [Mobile] = [] {
        didSet {
            catalogcollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        loadProducts()
    }
}

//Mark: Set up view
private extension CatalogViewController {
    
    func configureView() {
        view.backgroundColor = .white
        view.addSubview(brandheaderView)
        brandheaderView.fill(leading: view.leadingAnchor, trailing: view.trailingAnchor, top: view.safeTop)
        view.addSubview(catalogcollectionView)
        catalogcollectionView.fill(leading: view.leadingAnchor, trailing: view.trailingAnchor, top: brandheaderView.bottomAnchor, bottom: view.safeBottom)
    }
    
    func refresh(products: [Mobile]) {
        DispatchQueue.main.async { [weak self] in
            self?.datasource = products
            self?.brandheaderView.titles = Mobile.completeBrands(products: products)
        }
    }
}

//Mark: API calls
private extension CatalogViewController {
    func loadProducts() {
        LoadingView.show()
        Mobile.loadCatalogs(onSuccess: { [weak self] products in
            LoadingView.dismiss()
            self?.refresh(products: products)
        }, onFailure: { error in
            LoadingView.dismiss()
            DispatchQueue.main.async { 
                UIAlertController.ok(message: error.localizedDescription)
            }
        })
    }
}

//Mark: Subview creations
private extension CatalogViewController {
    
    func createCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = collectionViewSpacing
        layout.minimumLineSpacing = collectionViewSpacing
        let width = (view.frame.width - collectionViewSpacing) / 2
        layout.itemSize = CGSize(width: width, height: width + 50)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.registerNib(CatalogCollectionViewCell.self)
        cv.dataSource = self
        cv.backgroundColor = .clear
        return cv
    }
}

//Mark: CollectinView datasource methods
extension CatalogViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = CatalogCollectionViewCell.dequeueReusableCell(in: collectionView, indexPath: indexPath)
        cell.mobile = datasource[indexPath.item]
        return cell
    }
}
