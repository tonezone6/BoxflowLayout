//
//  FullWidthLayout.swift
//  sport.ro
//
//  Created by Alex on 18/10/2019.
//  Copyright © 2019 Alex Stratu. All rights reserved.
//

import UIKit

final class BoxflowLayout: UICollectionViewFlowLayout {
    weak var delegate: BoxflowLayoutDelegate?
    
    private var cache: [UICollectionViewLayoutAttributes] = []

    private var columns = 1
    private var contentHeight: CGFloat = 0
   
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        return collectionView.bounds.width - sectionInset.left - sectionInset.right
    }
    
    private var spacing: CGFloat {
        return minimumInteritemSpacing * (CGFloat(columns) - 1)
    }
    
    public var columnWidth: CGFloat {
        return (contentWidth - spacing)/CGFloat(columns)
    }
    
    convenience init(columns: Int) {
        self.init()
        sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        minimumLineSpacing = 8
        minimumInteritemSpacing = 16
        self.columns = columns
    }
}

extension BoxflowLayout {
    override var collectionViewContentSize: CGSize{
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        calculateFrames()
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cache.filter { rect.intersects($0.frame) }
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache.first { $0.indexPath == indexPath }
    }
    
    override func invalidateLayout() {
        super.invalidateLayout()
        cache.removeAll()
    }
}

extension BoxflowLayout {
    
    enum AttributeTarget {
        case cell, header, footer
    }
    
    private func setAttributes(frame: CGRect, for target: AttributeTarget, at indexPath: IndexPath) {
        var attributes: UICollectionViewLayoutAttributes?
        switch target {
        case .cell:     attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        case .header:   attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: indexPath)
        case .footer:   attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, with: indexPath)
        }
        attributes?.frame = frame
        if let attributes = attributes {
            cache.append(attributes)
        }
    }
    
    /*
     A minimum line spacing is returned if item is not the last in section.
     Contrary, line spacing is returned only if there's a footer available */
    private func minimumLineSpacing(for indexPath: IndexPath, footer: CGFloat?) -> CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        if indexPath.row == collectionView.numberOfItems(inSection: indexPath.section) - 1 {
            if let height = footer, height > 0 {
                return minimumLineSpacing
            } else {
                return 0
            }
        } else {
            return minimumLineSpacing
        }
    }
    
    private func calculateFrames() {
        guard let collectionView = collectionView, cache.isEmpty else { return }
        
        var frame: CGRect = .zero
        
        var xSectionOffset: [CGFloat] = []
        var ySectionOffset: [CGFloat] = []
        
        // Setup default x column offset
        for i in 0..<columns {
            let xcOffset = CGFloat(i) * (columnWidth + minimumInteritemSpacing)
            xSectionOffset.append(xcOffset)
            ySectionOffset.append(0)
        }
      
        // Iterate in each section to calculate frame for every item (header, cell, footer)
        for section in 0..<collectionView.numberOfSections {
            let headerHeight = delegate?.boxFlowLayout(self, heightForHeaderInSection: section)
            let footerHeight = delegate?.boxFlowLayout(self, heightForFooterInSection: section)
            
            let sectionFlow = delegate?.boxFlowLayout(self, flowInSection: section)
            
            // Find shortest column (index) to place items
            var scindex = 0
            if let minYOffset = ySectionOffset.min() {
                scindex = ySectionOffset.firstIndex(of: minYOffset) ?? 0
                ySectionOffset[scindex] += sectionInset.bottom
            }
         
            // MARK: Section header
            if let height = headerHeight, height > 0 {
                frame = CGRect(
                    x: xSectionOffset[scindex] + sectionInset.left,
                    y: ySectionOffset[scindex],
                    width: columnWidth, height: height
                )
                let indexPath = IndexPath(item: 0, section: section)
                setAttributes(frame: frame, for: .header, at: indexPath)
                ySectionOffset[scindex] += height + minimumLineSpacing
            }
            
            for item in 0..<collectionView.numberOfItems(inSection: section) {
                let indexPath = IndexPath(item: item, section: section)
    
                switch sectionFlow {
                    
                case .plain(let itemHeight):
                    
                    frame = CGRect(
                        x: xSectionOffset[scindex] + sectionInset.left,
                        y: ySectionOffset[scindex],
                        width: columnWidth,
                        height: itemHeight
                    )
                    ySectionOffset[scindex] += itemHeight + minimumLineSpacing(for: indexPath, footer: footerHeight)
                    setAttributes(frame: frame, for: .cell, at: indexPath)
                
                case .featuredGrid(let featuredHeight, let itemHeight):
                    
                    if indexPath.row == 0 {
                        let featuredItemSize = CGSize(
                            width: columnWidth,
                            height: featuredHeight
                        )
                        frame = CGRect(
                            x: xSectionOffset[scindex] + sectionInset.left,
                            y: ySectionOffset[scindex],
                            width: featuredItemSize.width, height: featuredItemSize.height
                        )
                        ySectionOffset[scindex] += featuredItemSize.height + minimumLineSpacing
                    } else {
                        let gridItemSize = CGSize(
                            width: (columnWidth - minimumLineSpacing)/2,
                            height: itemHeight
                        )
                        frame = CGRect(
                            x: xSectionOffset[scindex] + sectionInset.left,
                            y: ySectionOffset[scindex],
                            width: gridItemSize.width, height: gridItemSize.height
                        )
                        
                        xSectionOffset[scindex] += gridItemSize.width + minimumLineSpacing
                        
                        // MARK: Move to next row
                        let xlimit = CGFloat(scindex + 1) * columnWidth
                            + minimumInteritemSpacing * (CGFloat(scindex))
                        // print("limit ", xlimit)
                        
                        let xreset = CGFloat(scindex) * columnWidth
                            + minimumInteritemSpacing * (CGFloat(scindex))
                        // print("xreset", xreset)
                        
                        if xSectionOffset[scindex] > xlimit {
                            xSectionOffset[scindex] = xreset
                            ySectionOffset[scindex] += gridItemSize.height + minimumLineSpacing(for: indexPath, footer: footerHeight)
                        }
                    }
                    setAttributes(frame: frame, for: .cell, at: indexPath)
        
                case .featuredRows(let h1, let h2):
                    // MARK: Cell - featured row mode
                    if indexPath.row == 0 {
                        let size = CGSize(width: columnWidth, height: h1)
                        frame = CGRect(
                            x: xSectionOffset[scindex] + sectionInset.left,
                            y: ySectionOffset[scindex],
                            width: size.width,
                            height: size.height
                        )
                        ySectionOffset[scindex] += size.height + minimumLineSpacing
                    } else {
                        let size = CGSize(width: columnWidth, height: h2)
                        frame = CGRect(
                            x: xSectionOffset[scindex] + sectionInset.left,
                            y: ySectionOffset[scindex],
                            width: size.width,
                            height: size.height
                        )
                        ySectionOffset[scindex] += size.height
                        ySectionOffset[scindex] += minimumLineSpacing(for: indexPath, footer: footerHeight)
                    }
                    setAttributes(frame: frame, for: .cell, at: indexPath)
                
                default:
                    itemSize = CGSize(width: 40, height: 40)
                }
                
                // MARK: Section footer
                let lastItemInSection = collectionView.numberOfItems(inSection: section) - 1
                if indexPath.row == lastItemInSection, let height = footerHeight, height > 0 {
                    frame = CGRect(
                        x: xSectionOffset[scindex] + sectionInset.left,
                        y: ySectionOffset[scindex],
                        width: columnWidth, height: height
                    )
                    ySectionOffset[scindex] += height
                    setAttributes(frame: frame, for: .footer, at: IndexPath(item: lastItemInSection, section: section))
                }
            }
            
        // MARK: Content height
        contentHeight = frame.maxY + sectionInset.bottom
        }
    }
}
