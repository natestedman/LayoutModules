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
        count: Int,
        origin: Point,
        majorAxis: Axis,
        minorDimension: CGFloat
    ) -> LayoutResult
    
    /// A function type for dynamically calculating a dimension of a given item.
    public typealias CalculateDimension = (index: Int, axis: Axis, otherDimension: CGFloat) -> CGFloat
    
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
        self.layout = layoutModule.layoutAttributesWith
    }
}

// MARK: - LayoutModuleType
extension LayoutModule: LayoutModuleType
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
    public func layoutAttributesWith(count count: Int, origin: Point, majorAxis: Axis, minorDimension: CGFloat)
        -> LayoutResult
    {
        return layout(count: count, origin: origin, majorAxis: majorAxis, minorDimension: minorDimension)
    }
}
