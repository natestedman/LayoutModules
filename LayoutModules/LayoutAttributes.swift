// LayoutModules
// Written in 2016 by Nate Stedman <nate@natestedman.com>
//
// To the extent possible under law, the author(s) have dedicated all copyright and
// related and neighboring rights to this software to the public domain worldwide.
// This software is distributed without any warranty.
//
// You should have received a copy of the CC0 Public Domain Dedication along with
// this software. If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.

import UIKit

/// A axis-agnostic value-type representation of a collection view layout attributes object.
///
/// The properties of this type are equivalent to those in `UICollectionViewLayoutAttributes` - consult Apple's
/// documentation for that class for more information.
public struct LayoutAttributes
{
    // MARK: - Initialization

    /**
     Initializes a layout attributes value.

     - parameter frame:       The frame for the layout attributes.
     - parameter transform3D: A 3D transformation to apply. The default value is `CATransform3DIdentity`.
     - parameter transform:   An affine transformation to apply. The default value is `CGAffineTransformIdentity`.
     - parameter alpha:       The alpha value. The default value is `1`.
     - parameter zIndex:      The z index. The default value is `0`.
     - parameter hidden:      Whether or not the cell should be hidden. The default value is `false`.
     */
    public init(frame: Rect,
                transform3D: CATransform3D = CATransform3DIdentity,
                transform: CGAffineTransform = CGAffineTransform.identity,
                alpha: CGFloat = 1,
                zIndex: Int = 0,
                hidden: Bool = false)
    {
        self.frame = frame
        self.transform3D = transform3D
        self.transform = transform
        self.alpha = alpha
        self.zIndex = zIndex
        self.hidden = hidden
    }

    /**
     Initializes a layout attributes value from a UIKit layout attributes object.

     - parameter layoutAttributes: The layout attributes object.
     - parameter majorAxis:        The major axis to use when converting the `frame` property.
     */
    internal init(layoutAttributes: UICollectionViewLayoutAttributes, majorAxis: Axis)
    {
        self.init(
            frame: Rect(CGRect: layoutAttributes.frame, majorAxis: majorAxis),
            transform3D: layoutAttributes.transform3D,
            transform: layoutAttributes.transform,
            alpha: layoutAttributes.alpha,
            zIndex: layoutAttributes.zIndex,
            hidden: layoutAttributes.isHidden
        )
    }

    // MARK: - Attributes

    /// The frame for the layout attributes.
    public var frame: Rect

    /// A 3D transformation to apply.
    public var transform3D: CATransform3D

    /// An affine transformation to apply.
    public var transform: CGAffineTransform

    /// The alpha value.
    public var alpha: CGFloat

    /// The z index.
    public var zIndex: Int

    /// Whether or not the cell should be hidden.
    public var hidden: Bool
}

extension LayoutAttributes
{
    internal func collectionViewLayoutAttributesForIndexPath(_ indexPath: IndexPath, withMajorAxis majorAxis: Axis)
        -> UICollectionViewLayoutAttributes
    {
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.frame = frame.CGRect(majorAxis: majorAxis)
        attributes.transform3D = transform3D
        attributes.transform = transform
        attributes.alpha = alpha
        attributes.zIndex = zIndex
        attributes.isHidden = hidden

        return attributes
    }
}
