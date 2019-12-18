//
//  CustomDataSource.swift
//  BoxFlowLayout
//
//  Created by Alex on 17/12/2019.
//  Copyright © 2019 Alex. All rights reserved.
//

import UIKit

class CustomDataSource: NSObject {
    public var cellConfiguration: ((UICollectionViewCell) -> Void)?
    public var headerConfiguration: ((UICollectionReusableView) -> Void)?
    public var footerConfiguration: ((UICollectionReusableView) -> Void)?

    private var sections: [Section] = []
    init(sections: [Section]) {
        self.sections = sections
    }
}

extension CustomDataSource: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch sections[section] {
        case .plain:
            return 3
        case .featured:
            return 4
        case .grid:
            return 5
        }
    }
       
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cellConfiguration?(cell)
        return cell
    }
       
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)
            headerConfiguration?(header)
            return header
        case UICollectionView.elementKindSectionFooter:
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footer", for: indexPath)
            footerConfiguration?(footer)
            return footer
        default:
            fatalError()
        }
    }
}
