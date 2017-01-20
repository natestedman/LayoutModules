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
    public convenience init(majorAxis: Axis, moduleForSection: @escaping (_ section: Int) -> LayoutModuleType)
    {
        self.init()
        self.majorAxis = majorAxis
        self.moduleForSection = moduleForSection
    }

    // MARK: - Major Axis

    /// The major (scrolling) axis for the layout. By default, this is `Vertical`.
    public var majorAxis = Axis.vertical
    {
        didSet { invalidateLayout() }
    }
    
    // MARK: - Modules
    
    /// A function to determine the layout module for each section.
    ///
    /// This property should be assigned a value by clients before performing layout.
    public var moduleForSection: ((_ section: Int) -> LayoutModuleType)?
    {
        didSet { invalidateLayout() }
    }
    
    // MARK: - Layout Implementation
    
    /// Prepares the layout.
    ///
    /// This function is an implementation detail of `UICollectionViewLayout`, and should not be called by clients.
    public override func prepare()
    {
        if let collectionView = self.collectionView
        {
            let minorDimension: CGFloat

            switch majorAxis
            {
            case .horizontal:
                minorDimension = collectionView.bounds.size.height
            case .vertical:
                minorDimension = collectionView.bounds.size.width
            }

            var origin = Point(major: 0, minor: 0)
            
            self.layoutAttributes = (0..<collectionView.numberOfSections).map({ section in
                // use a default layout module if one is not provided
                let module = moduleForSection?(section) ?? LayoutModule.table(majorDimension: 44)

                let items = collectionView.numberOfItems(inSection: section)
                let result = module.layoutAttributesWith(
                    count: items,
                    origin: origin,
                    majorAxis: majorAxis,
                    minorDimension: minorDimension
                )

                origin.major = result.finalOffset

                return zip(result.layoutAttributes, 0..<items).map({ layoutAttributes, item in
                    layoutAttributes.collectionViewLayoutAttributesForIndexPath(
                        IndexPath(item: item, section: section),
                        withMajorAxis: majorAxis
                    )
                })
            })

            self.contentSize = Size(major: origin.major, minor: minorDimension).CGSize(majorAxis: majorAxis)
        }
        else
        {
            self.contentSize = CGSize.zero
            self.layoutAttributes = []
        }
    }

    /**
     Returns the initial layout attributes for the item at the specified index path.

     - parameter itemIndexPath: The index path.
     */
    public override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath)
        -> UICollectionViewLayoutAttributes?
    {
        guard let layoutAttributes = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath) else {
            return nil
        }

        let attributes = LayoutAttributes(layoutAttributes: layoutAttributes, majorAxis: majorAxis)

        return moduleForSection?(itemIndexPath.section)
            .initialLayoutAttributesFor(itemIndexPath, attributes: attributes)?
            .collectionViewLayoutAttributesForIndexPath(itemIndexPath, withMajorAxis: majorAxis)
    }

    /**
     Returns the final layout attributes for the item at the specified index path.

     - parameter itemIndexPath: The index path.
     */
    public override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath)
        -> UICollectionViewLayoutAttributes?
    {
        guard let layoutAttributes = super.finalLayoutAttributesForDisappearingItem(at: itemIndexPath) else {
            return nil
        }

        let attributes = LayoutAttributes(layoutAttributes: layoutAttributes, majorAxis: majorAxis)

        return moduleForSection?(itemIndexPath.section)
            .finalLayoutAttributesFor(itemIndexPath, attributes: attributes)?
            .collectionViewLayoutAttributesForIndexPath(itemIndexPath, withMajorAxis: majorAxis)
    }
    
    /// Determines if the layout should be invalidated, based on a bounds change.
    ///
    /// This function is an implementation detail of `UICollectionViewLayout`, and should not be called by clients.
    public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool
    {
        return (self.collectionView?.bounds ?? CGRect.zero).size.width != newBounds.size.width
    }
    
    // MARK: - Content Size Implementation
    fileprivate var contentSize = CGSize.zero
    
    /// The content size of the layout.
    ///
    /// This property is an implementation detail of `UICollectionViewLayout`, and should not be called by clients.
    public override var collectionViewContentSize : CGSize
    {
        return contentSize
    }
    
    // MARK: - Layout Attributes Implementation
    fileprivate var layoutAttributes: [[UICollectionViewLayoutAttributes]] = []
    {
        didSet
        {
            // this is an optimization for querying the layout attributes within a rect
            self.flatLayoutAttributes = layoutAttributes.reduce([], +)
        }
    }
    
    fileprivate var flatLayoutAttributes: [UICollectionViewLayoutAttributes] = []
    
    /**
    Returns the layout attributes object for the item at the specified index path.
    
    This function is an implementation detail of `UICollectionViewLayout`, and should not be called by clients.
    
    - parameter indexPath: The index path.
    */
    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes?
    {
        return layoutAttributes[indexPath.section][indexPath.item]
    }
    
    /**
     Returns the layout attributes objects for the items within the specified rect.
     
     This function is an implementation detail of `UICollectionViewLayout`, and should not be called by clients.
     
     - parameter rect: The rect.
     */
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]?
    {
        return flatLayoutAttributes.filter({ attributes in
            return attributes.frame.intersects(rect)
        })
    }
}
