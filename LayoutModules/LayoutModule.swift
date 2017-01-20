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
        _ count: Int,
        _ origin: Point,
        _ majorAxis: Axis,
        _ minorDimension: CGFloat
    ) -> LayoutResult

    /// A function that provides the initial or final layout attributes for an index path, if any.
    public typealias TransitionLayout = (IndexPath, LayoutAttributes) -> LayoutAttributes?

    /// A function type for dynamically calculating a dimension of a given item.
    public typealias CalculateDimension = (_ index: Int, _ axis: Axis, _ otherDimension: CGFloat) -> CGFloat

    /// The layout function.
    fileprivate let layout: Layout

    /// The initial layout attributes function.
    fileprivate let initialLayout: TransitionLayout?

    /// The final layout attributes function.
    fileprivate let finalLayout: TransitionLayout?

    // MARK: - Initialization

    /**
    Initializes a layout module.

    - parameter layout: The function to use for layout.
    */
    public init(layout: @escaping Layout)
    {
        self.layout = layout
        self.initialLayout = { _ in nil }
        self.finalLayout = { _ in nil }
    }

    /**
     Initializes a layout module.

     - parameter layout:        The function to use for layout.
     - parameter initialLayout: The function to use for initial layout attributes.
     - parameter finalLayout:   The function to use for final layout attributes.
     */
    public init(layout: @escaping Layout, initialLayout: TransitionLayout? = nil, finalLayout: TransitionLayout? = nil)
    {
        self.layout = layout
        self.initialLayout = initialLayout
        self.finalLayout = finalLayout
    }

    /**
     Initializes a layout module, by erasing the type of another module.

     - parameter layoutModule: The layout module.
     */
    public init(layoutModule: LayoutModuleProtocol)
    {
        self.layout = layoutModule.layoutResult
        self.initialLayout = layoutModule.initialLayoutAttributes
        self.finalLayout = layoutModule.finalLayoutAttributes
    }
}

// MARK: - LayoutModuleType
extension LayoutModule: LayoutModuleProtocol
{
    // MARK: - Layout

    /**
     Performs layout for a section.

     - parameter attributes:     The array of attributes to update.
     - parameter origin:         The origin of the module.
     - parameter majorAxis:      The major axis for the layout.
     - parameter minorDimension: The minor, or non-scrolling, dimension of the module.
     
     - returns: A layout result for the section, including the layout attributes for each item, and the new initial
                major direction offset for the next section.
     */
    public func layoutResult(count: Int, origin: Point, majorAxis: Axis, minorDimension: CGFloat) -> LayoutResult
    {
        return layout(count, origin, majorAxis, minorDimension)
    }

    // MARK: - Initial & Final Layout Attributes

    /**
     Provides the initial layout attributes for an appearing item.

     - parameter indexPath:  The index path of the appearing item.
     - parameter attributes: The layout attributes of the appearing item.

     - returns: A layout attributes value, or `nil`.
     */
    public func initialLayoutAttributes(indexPath: IndexPath, attributes: LayoutAttributes) -> LayoutAttributes?
    {
        return initialLayout?(indexPath, attributes)
    }

    /**
     Provides the final layout attributes for an disappearing item.

     - parameter indexPath:  The index path of the disappearing item.
     - parameter attributes: The layout attributes of the disappearing item.

     - returns: A layout attributes value, or `nil`.
     */
    public func finalLayoutAttributes(indexPath: IndexPath, attributes: LayoutAttributes) -> LayoutAttributes?
    {
        return finalLayout?(indexPath, attributes)
    }
}
