//
//  ViewController.swift
//  CustomCollectionViewFlow
//
//  Created by Alex on 17/12/2019.
//  Copyright © 2019 Alex. All rights reserved.
//

import UIKit

struct Color {
    static let primary = UIColor(hex: "#e4c85e")
    static let secondary = UIColor(hex: "#fbf2d2")
}

enum Section {
    case featured, plain, grid
}

final class ViewController: UIViewController {
    private var sections: [Section] = [.plain, .grid]
    
    private var collectionView: UICollectionView!
    private var boxLayout: BoxflowLayout!
    
    private var customDelegate: CustomDelegate!
    private var customDataSource: CustomDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupProviders()
    }
    
    private func setupCollectionView() {
        boxLayout = BoxflowLayout(columns: 1)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: boxLayout)
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        collectionView.register(
            UICollectionViewCell.self,
            forCellWithReuseIdentifier: "cell"
        )
        collectionView.register(
            UICollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "header"
        )
        collectionView.register(
            UICollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: "footer"
        )
        collectionView.backgroundColor = .white
    }
    
    private func setupProviders() {
        customDelegate = CustomDelegate(sections: sections)
        boxLayout.delegate = customDelegate
        
        customDataSource = CustomDataSource(sections: sections)
        customDataSource.cellConfiguration = { cell in
            cell.backgroundColor = Color.primary
        }
        customDataSource.headerConfiguration = { header in
            header.backgroundColor = Color.secondary
        }
        customDataSource.footerConfiguration = { footer in
            footer.backgroundColor = Color.secondary
        }
        collectionView.dataSource = customDataSource
    }
}
