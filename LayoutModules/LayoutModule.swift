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

/// A basic layout module, which uses a function to perform layout.
///
/// This type can also be used to erase the type of any other layout module, and provides an initializer to do so.
public struct LayoutModule
{
    // MARK: - Layout Attributes
    
    /// A layout function, which implements the functionality of `ModuleType`.
    public typealias Layout = (
        attributes: [UICollectionViewLayoutAttributes],
        origin: CGPoint,
        width: CGFloat
    ) -> CGFloat
    
    /// A function type for dynamically calculating the height of a given item.
    public typealias CalculateHeight = (index: Int, width: CGFloat) -> CGFloat
    
    /// The layout function.
    private let layout: Layout
    
    // MARK: - Initialization
    
    /**
    Initializes a layout module.
    
    - parameter layout: The function to use for layout.
    */
    public init(layout: Layout)
    {
        self.layout = layout
    }
    
    /**
     Initializes a layout module, by erasing the type of another module.
     
     - parameter layoutModule: The layout module.
     */
    public init(layoutModule: LayoutModuleType)
    {
        self.layout = layoutModule.prepareLayoutAttributes
    }
}

// MARK: - LayoutModuleType
extension LayoutModule: LayoutModuleType
{
    // MARK: - Layout
    
    /**
    Updates the layout attribute objects with layout information.
    
    - parameter attributes: The array of attributes to update.
    - parameter origin:     The origin of the module.
    - parameter width:      The width of the module.
    
    - returns: The new Y offset, used for the next layout module.
    */
    public func prepareLayoutAttributes(attributes: [UICollectionViewLayoutAttributes], origin: CGPoint, width: CGFloat) -> CGFloat
    {
        return layout(attributes: attributes, origin: origin, width: width)
    }
}
