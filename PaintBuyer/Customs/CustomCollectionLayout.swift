//
//  CustomCollectionLayout.swift
//  PaintBuyer
//
//  Created by Olga Padaliakina on 24.07.2018.
//  Copyright © 2018 podoliakina. All rights reserved.
//

import UIKit

protocol CustomLayoutDelegate : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, columnCountForSection section: Int) -> Int
}

class CustomCollectionLayout: UICollectionViewFlowLayout {
    
    weak var delegate: CustomLayoutDelegate?
    var columnCount: Int = 0
    var contentHeight: CGFloat = 0

    override init() {
        super.init()
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    // MARK: -
    
    func setup() {
        self.minimumInteritemSpacing = 10
        self.minimumLineSpacing = 10
        self.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10)
        
        if let collectionView = self.collectionView, let columns = self.delegate?.collectionView(collectionView, layout: self, columnCountForSection: 0) {
            self.columnCount = columns
        }
        
        let itemWidth = UIScreen.main.bounds.size.width - (CGFloat(self.columnCount + 1) * self.minimumInteritemSpacing) / CGFloat(self.columnCount)
        
        self.itemSize = CGSize(width: itemWidth, height: itemWidth)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var itemAttributes = [UICollectionViewLayoutAttributes]()
        self.contentHeight = 0
        
        let itemCount = self.collectionView?.numberOfItems(inSection: 0) ?? 0
        var columnHeights = [CGFloat]()
        let minimumLineSpacing = self.minimumLineSpacing(forSection: 0)
        let minimumInteritemSpacing = self.minimumInteritemSpacing(forSection: 0)
        let sectionInset = self.sectionInset(forSection: 0)
        
        self.contentHeight += sectionInset.top
        
        for _ in 0..<columnCount {
            columnHeights.append(self.contentHeight)
        }
        
        for i in 0..<itemCount {
            let indexPath = IndexPath.init(item: i, section: 0)
            
            let columnIndex: Int = columnHeights.index(of: columnHeights.min()!) ?? 0
            
            let size = self.itemSize(for: indexPath)
            let x = sectionInset.left + (size.width + minimumInteritemSpacing) * CGFloat(columnIndex)
            
            let attributes = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)
            
            attributes.frame = CGRect(x: x, y: columnHeights[columnIndex], width: size.width, height: size.height)
            itemAttributes.append(attributes)
            
            columnHeights[columnIndex] = attributes.frame.maxY + minimumLineSpacing
        }
        
        self.contentHeight = columnHeights.max()!
        
        if itemCount == 0 {
            self.contentHeight = self.contentHeight + UIScreen.main.bounds.size.height
        }
        
        self.contentHeight += sectionInset.bottom
        
        return itemAttributes
    }
    
    override var collectionViewContentSize: CGSize {
        set {
            self.collectionViewContentSize = newValue
        }
        get {
            return CGSize(width: self.collectionView!.frame.size.width, height: self.contentHeight)
        }
    }
    
    // MARK: -
    
    func minimumLineSpacing(forSection section: Int) -> CGFloat {
        if let space = self.delegate?.collectionView!(self.collectionView!, layout: self, minimumLineSpacingForSectionAt: section) {
            return space
        }
        return self.minimumLineSpacing
    }
    
    func minimumInteritemSpacing(forSection section: Int) -> CGFloat {
        if let collectionView = self.collectionView,
            let space = self.delegate?.collectionView!(collectionView, layout: self, minimumInteritemSpacingForSectionAt: section) {
            return space
        }
        return self.minimumInteritemSpacing
    }
    
    func sectionInset(forSection section: Int) -> UIEdgeInsets {
        if let collectionView = self.collectionView,
            let inset = self.delegate?.collectionView!(collectionView, layout: self, insetForSectionAt: section) {
            return inset
        }
        return self.sectionInset
    }
    
    func itemSize(for indexPath: IndexPath) -> CGSize {
        if let collectionView = self.collectionView,
            let size = self.delegate?.collectionView!(collectionView, layout: self, sizeForItemAt: indexPath) {
            return size
        }
        return self.itemSize
    }
}
