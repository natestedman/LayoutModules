// LayoutModules
// Written in 2015 by Nate Stedman <nate@natestedman.com>
//
// To the extent possible under law, the author(s) have dedicated all copyright and
// related and neighboring rights to this software to the public domain worldwide.
// This software is distributed without any warranty.
//
// You should have received a copy of the CC0 Public Domain Dedication along with
// this software. If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.

import UIKit

/// A collection view layout which uses `LayoutModuleType` values to create its layout.
public final class LayoutModulesCollectionViewLayout: UICollectionViewLayout
{
    // MARK: - Initialization
    
    /**
    Initializes a `LayoutModulesCollectionViewLayout`.
    
    - parameter moduleForSection: A function to determine the layout module for each section.
    */
    public convenience init(moduleForSection: (section: Int) -> LayoutModuleType)
    {
        self.init()
        self.moduleForSection = moduleForSection
    }
    
    // MARK: - Modules
    
    /// A function to determine the layout module for each section.
    ///
    /// This property should be assigned a value by clients before performing layout.
    public var moduleForSection: ((section: Int) -> LayoutModuleType)?
    
    // MARK: - Layout Implementation
    
    /// Prepares the layout.
    ///
    /// This function is an implementation detail of `UICollectionViewLayout`, and should not be called by clients.
    public override func prepareLayout()
    {
        if let collectionView = self.collectionView
        {
            let width = collectionView.bounds.size.width
            var origin = CGPointZero
            
            self.layoutAttributes = (0..<collectionView.numberOfSections()).map({ section in
                let attributes = (0..<collectionView.numberOfItemsInSection(section)).map({ item in
                    return UICollectionViewLayoutAttributes(forCellWithIndexPath: NSIndexPath(forItem: item, inSection: section))
                })
                
                if let module = moduleForSection?(section: section)
                {
                    origin.y = module.prepareLayoutAttributes(attributes, origin: origin, width: width)
                }
                
                return attributes
            })
            
            self.contentSize = CGSize(width: width, height: origin.y)
        }
        else
        {
            self.contentSize = CGSizeZero
            self.layoutAttributes = []
        }
    }
    
    /// Determines if the layout should be invalidated, based on a bounds change.
    ///
    /// This function is an implementation detail of `UICollectionViewLayout`, and should not be called by clients.
    public override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool
    {
        return (self.collectionView?.bounds ?? CGRectZero).size.width != newBounds.size.width
    }
    
    // MARK: - Content Size Implementation
    private var contentSize = CGSizeZero
    
    /// The content size of the layout.
    ///
    /// This property is an implementation detail of `UICollectionViewLayout`, and should not be called by clients.
    public override func collectionViewContentSize() -> CGSize
    {
        return contentSize
    }
    
    // MARK: - Layout Attributes Implementation
    private var layoutAttributes: [[UICollectionViewLayoutAttributes]] = []
    {
        didSet
        {
            // this is an optimization for querying the layout attributes within a rect
            self.flatLayoutAttributes = layoutAttributes.reduce([], combine: +)
        }
    }
    
    private var flatLayoutAttributes: [UICollectionViewLayoutAttributes] = []
    
    /**
    Returns the layout attributes object for the item at the specified index path.
    
    This function is an implementation detail of `UICollectionViewLayout`, and should not be called by clients.
    
    - parameter indexPath: The index path.
    */
    public override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes?
    {
        return layoutAttributes[indexPath.section][indexPath.item]
    }
    
    /**
     Returns the layout attributes objects for the items within the specified rect.
     
     This function is an implementation detail of `UICollectionViewLayout`, and should not be called by clients.
     
     - parameter rect: The rect.
     */
    public override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]?
    {
        return flatLayoutAttributes.filter({ attributes in
            return CGRectIntersectsRect(attributes.frame, rect)
        })
    }
}
