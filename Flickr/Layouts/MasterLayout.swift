//
//  MasterLayout.swift
//  Flickr
//
//  Created by Kautsya Kanu on 19/10/17.
//  Copyright © 2017 Kautsya Kanu. All rights reserved.
//

import UIKit

protocol MasterLayoutDelegate: class {
	func collectionView(_ collectionView:UICollectionView,
	                    heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat
}

class MasterLayout: UICollectionViewLayout {
	
	// MARK: Variables
	weak var delegate: MasterLayoutDelegate!
	private var numberOfColumns = UIApplication.shared.statusBarOrientation.isLandscape ? 3:2
	private var cellPadding: CGFloat = 6
	var cache = [UICollectionViewLayoutAttributes]()
	var contentHeight: CGFloat = 0
	private var contentWidth: CGFloat {
		guard let collectionView = collectionView else {
			return 0
		}
		let insets = collectionView.contentInset
		return collectionView.bounds.width - (insets.left + insets.right)
	}
	override var collectionViewContentSize: CGSize {
		return CGSize(width: contentWidth, height: contentHeight)
	}
	
	override func prepare() {
        super.prepare()
		guard cache.isEmpty == true, let collectionView = collectionView else {
			return
		}
		numberOfColumns = UIApplication.shared.statusBarOrientation.isLandscape ? 3:2
		let columnWidth = contentWidth / CGFloat(numberOfColumns)
		var xOffset = [CGFloat]()
		for column in 0 ..< numberOfColumns {
			xOffset.append(CGFloat(column) * columnWidth)
		}
		var column = 0
		var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)
		
		for item in 0 ..< collectionView.numberOfItems(inSection: 0) {
			let indexPath = IndexPath(item: item,
			                          section: 0)
			let photoHeight = delegate.collectionView(collectionView, heightForPhotoAtIndexPath: indexPath)
			let height = cellPadding * 2 + photoHeight
			let frame = CGRect(x: xOffset[column],
			                   y: yOffset[column],
			                   width: columnWidth,
			                   height: height)
			let insetFrame = frame.insetBy(dx: cellPadding,
			                               dy: cellPadding)
			let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
			attributes.frame = insetFrame
			cache.append(attributes)
			yOffset[column] = yOffset[column] + height
			contentHeight = max(contentHeight, yOffset[column])
			
			let minElement = yOffset.min() ?? 0
			column = yOffset.firstIndex(of: minElement) ?? 0
		}
	}
	
	override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
		var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
		for attributes in cache {
			if attributes.frame.intersects(rect) {
				visibleLayoutAttributes.append(attributes)
			}
		}
		return visibleLayoutAttributes
	}
	
	override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
		return cache[indexPath.item]
	}
}
