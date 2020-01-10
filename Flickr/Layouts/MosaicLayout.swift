//
//  MosaicLayout.swift
//  Flickr
//
//  Created by Kautsya Kanu on 19/10/17.
//  Copyright © 2017 Kautsya Kanu. All rights reserved.
//

import UIKit

protocol MosaicLayoutProtocol: class {
	func collectionView(_ collectionView:UICollectionView,
                        heightAt indexPath:IndexPath, for width:CGFloat) -> CGFloat
}

class MosaicLayout: UICollectionViewLayout {
	//MARK: Properties
    weak var delegate: MosaicLayoutProtocol!
    @IBInspectable private var landscapeColumns: Int = 3
    @IBInspectable private var portraitColumns: Int = 2
    @IBInspectable private var cellSpacing: CGFloat = 10
    @IBInspectable private var lineSpacing: CGFloat = 10
	// MARK: Variables
    private var numberOfColumns: Int {
        let isLandscape = UIApplication.shared.windows.first?.windowScene?
            .interfaceOrientation.isLandscape ?? false
        return isLandscape ? landscapeColumns:portraitColumns
    }
	private var cache = [UICollectionViewLayoutAttributes]()
	private var contentHeight: CGFloat = 0
	private var contentWidth: CGFloat {
		guard let collectionView = collectionView else { return 0 }
		let insets = collectionView.contentInset
		return collectionView.bounds.width - (insets.left + insets.right)
	}
    
	override var collectionViewContentSize: CGSize {
		return CGSize(width: contentWidth, height: contentHeight)
	}
	
	override func prepare() {
		guard let collectionView = collectionView else { return }
        let numberOfSpaces = numberOfColumns - 1
        let allSpaceWidth: CGFloat = numberOfSpaces * cellSpacing
        let allCellWidth = contentWidth - allSpaceWidth
        let columnWidth: CGFloat = allCellWidth/numberOfColumns
        //xOffset for each column
		var xOffset = [CGFloat]()
        var currentX: CGFloat = 0
		for _ in 0..<numberOfColumns {
            xOffset.append(currentX)
            currentX += columnWidth + cellSpacing
		}
        //yOffset for each column
        for section in 0..<collectionView.numberOfSections {
            var column = 0
            var yOffset = [CGFloat](repeating: contentHeight, count: numberOfColumns)
            for item in 0..<collectionView.numberOfItems(inSection: section) {
                let indexPath = IndexPath(item: item, section: section)
                let (cellX, cellY) = (xOffset[column], yOffset[column])
                let cellHeight = delegate.collectionView(collectionView, heightAt: indexPath, for: columnWidth)
                let cellFrame = CGRect(x: cellX, y: cellY,
                                          width: columnWidth, height: cellHeight)
                
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = cellFrame
                cache.append(attributes)
                
                yOffset[column] += cellHeight + lineSpacing
                let minElement = yOffset.min()! //Optimise
                column = yOffset.firstIndex(of: minElement)! //Optimise
            }
            contentHeight = yOffset.max()!
        }
	}
	
	override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleAttributes: [UICollectionViewLayoutAttributes] = []
		for attributes in cache {
			if attributes.frame.intersects(rect) {
				visibleAttributes.append(attributes)
			}
		}
		return visibleAttributes
	}
	
	override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
		return cache[indexPath.item]
	}
    
    func reset() {
        cache.removeAll()
        contentHeight = 0
        invalidateLayout()
    }
}
