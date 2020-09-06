//
//  CatalogViewController.swift
//  AxiomTelecom
//
//  Created by Sanu Sathyaseelan on 06/09/2020.
//  Copyright © 2020 Sanu. All rights reserved.
//

import UIKit

class CatalogViewController: UIViewController {
    
    private let searchController = UISearchController(searchResultsController: nil)
    private lazy var catalogcollectionView = createCollectionView()
    private lazy var brandheaderView = BrandView()
    
    private let collectionViewSpacing: CGFloat = 5
    
    private var fullDataSource: [String: [Mobile]] = [:]
    
    private var datasource: [Mobile] = [] {
        didSet {
            catalogcollectionView.reloadData()
        }
    }
    
    private var filteredDatasource: [Mobile] {
        getFilteredDatasource()
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
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.orange]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        title = "My Store"
        
        view.backgroundColor = .white
        view.addSubview(brandheaderView)
        brandheaderView.fill(leading: view.leadingAnchor, trailing: view.trailingAnchor, top: view.safeTop)
        view.addSubview(catalogcollectionView)
        catalogcollectionView.fill(leading: view.leadingAnchor, trailing: view.trailingAnchor, top: brandheaderView.bottomAnchor, bottom: view.safeBottom)
        
        brandheaderView.tapActionClosure = { [weak self] item in
            self?.datasource = self?.fullDataSource[item] ?? []
        }
        configureSearchController()
    }
        
    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func refresh(products: [String: [Mobile]]) {
        fullDataSource = products
        DispatchQueue.main.async { [weak self] in
            let titles = products.compactMap { $0.key }.sorted(by: <)
            self?.brandheaderView.titles = titles
            if let title = titles.first, let datasource =  products[title] {
                self?.datasource = datasource
            }
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
        return filteredDatasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = CatalogCollectionViewCell.dequeueReusableCell(in: collectionView, indexPath: indexPath)
        cell.mobile = filteredDatasource[indexPath.item]
        return cell
    }
}

extension CatalogViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        catalogcollectionView.reloadData()
    }
}

private extension CatalogViewController {
    
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var lowerCaseText: String {
        searchController.searchBar.text?.lowercased() ?? ""
    }
    
    func getFilteredDatasource() -> [Mobile] {
        
        guard !isSearchBarEmpty else { return datasource }
        
        return datasource.filter {
            $0.brand.lowercased().contains(lowerCaseText) || $0.model?.lowercased().contains(lowerCaseText) == true || $0.price.contains(lowerCaseText)
        }
    }
}
