//
//  BrandView.swift
//  AxiomTelecom
//
//  Created by Sanu Sathyaseelan on 06/09/2020.
//  Copyright © 2020 Sanu. All rights reserved.
//

import UIKit

class BrandView: UIView {
    
    // ui
    private lazy var collectionView = createCollectionView()
    
    // properties
    private var colorHeaderActive = UIColor.blue
    private var colorHeaderInActive = UIColor.gray
    private var colorHeaderBackground = UIColor.white
    private var currentPosition = 0

    // injections
    var titles = [String]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }

    override var intrinsicContentSize: CGSize {
        CGSize(width: 0, height: 57)
    }
}

private extension BrandView {
    
    func configure() {
        addSubview(collectionView)
        collectionView.fillInSuperView()
    }
    
    func setCurrentPosition(position: Int) {
        currentPosition = position
        let path = IndexPath(item: currentPosition, section: 0)
        
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.scrollToItem(at: path, at: .centeredHorizontally, animated: true)
            self?.collectionView.reloadData()
        }
    }
}

private extension BrandView {
    
    func createCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = colorHeaderBackground
        collectionView.register(HeaderCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }
}

extension BrandView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        setCurrentPosition(position: indexPath.row)
    }
}

extension BrandView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = HeaderCell.dequeueReusableCell(in: collectionView, indexPath: indexPath)
        cell.text = titles[indexPath.row]
        
        var didSelect = false
        
        if currentPosition == indexPath.row {
            didSelect = true
        }
        
        cell.select(didSelect: didSelect, activeColor: colorHeaderActive, inActiveColor: colorHeaderInActive)
        
        return cell
    }
}

extension BrandView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 3, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

private class HeaderCell: UICollectionViewCell {
    
    private let label = UILabel()
    private let indicator = UIView()

    var text: String? {
        didSet {
            label.text = text
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func select(didSelect: Bool, activeColor: UIColor, inActiveColor: UIColor){
        indicator.backgroundColor = activeColor
        
        if didSelect {
            label.textColor = activeColor
            indicator.isHidden = false
        }else{
            label.textColor = inActiveColor
            indicator.isHidden = true
        }
    }
    
    private func setupUI(){
        // view
        addSubview(label)
        addSubview(indicator)
        
        // label
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        // indicator
        indicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            indicator.bottomAnchor.constraint(equalTo: bottomAnchor),
            indicator.leadingAnchor.constraint(equalTo: leadingAnchor),
            indicator.trailingAnchor.constraint(equalTo: trailingAnchor),
            indicator.heightAnchor.constraint(equalToConstant: 2)
        ])
    }
}
