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

/// A base type for layout modules.
public protocol LayoutModuleType
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
    func layoutAttributesWith(count count: Int, origin: Point, majorAxis: Axis, minorDimension: CGFloat)
        -> LayoutResult

    // MARK: - Initial & Final Layout Attributes

    /**
     Provides the initial layout attributes for an appearing item.

     This function has a default implementation, which returns `nil`.

     - parameter indexPath:  The index path of the appearing item.
     - parameter attributes: The layout attributes of the appearing item.

     - returns: A layout attributes value, or `nil`.
     */
    func initialLayoutAttributesFor(indexPath: NSIndexPath, attributes: LayoutAttributes) -> LayoutAttributes?

    /**
     Provides the final layout attributes for an disappearing item.

     This function has a default implementation, which returns `nil`.

     - parameter indexPath:  The index path of the disappearing item.
     - parameter attributes: The layout attributes of the disappearing item.

     - returns: A layout attributes value, or `nil`.
     */
    func finalLayoutAttributesFor(indexPath: NSIndexPath, attributes: LayoutAttributes) -> LayoutAttributes?
}

extension LayoutModuleType
{
    // MARK: - Default Implementations for Initial & Final Layout Attributes
    public func initialLayoutAttributesFor(indexPath: NSIndexPath, attributes: LayoutAttributes) -> LayoutAttributes?
    {
        return nil
    }

    public func finalLayoutAttributesFor(indexPath: NSIndexPath, attributes: LayoutAttributes) -> LayoutAttributes?
    {
        return nil
    }
}

extension LayoutModuleType
{
    // MARK: - Adding Initial & Final Layout Attributes

    /**
     Creates a layout module that overrides the initial transition behavior of the receiver.

     - parameter transition: A function that produces initial layout attributes.
     */
    public func withInitialTransition(transition: LayoutModule.TransitionLayout) -> LayoutModule
    {
        return LayoutModule(
            layout: layoutAttributesWith,
            initialLayout: transition,
            finalLayout: finalLayoutAttributesFor
        )
    }

    /**
     Creates a layout module that overrides the final transition behavior of the receiver.

     - parameter transition: A function that produces final layout attributes.
     */
    public func withFinalTransition(transition: LayoutModule.TransitionLayout) -> LayoutModule
    {
        return LayoutModule(
            layout: layoutAttributesWith,
            initialLayout: initialLayoutAttributesFor,
            finalLayout: transition
        )
    }
}

extension LayoutModuleType
{
    // MARK: - Insets

    /**
     Produces a new layout module by insetting the layout module.
     
     All parameters are optional. If a parameter is omitted, that edge will not be inset.
     
     - parameter minMajor: Insets from the minimum end of the major axis.
     - parameter maxMajor: Insets from the maximum end of the major axis.
     - parameter minMinor: Insets from the minimum end of the minor axis.
     - parameter maxMinor: Insets from the maximum end of the minor axis.
     
     - returns: A new layout module, derived from the module this function was called on.
     */
    public func inset(minMajor minMajor: CGFloat = 0,
                      maxMajor: CGFloat = 0,
                      minMinor: CGFloat = 0,
                      maxMinor: CGFloat = 0) -> LayoutModule
    {
        return LayoutModule { count, origin, majorAxis, minorDimension in
            let insetOrigin = Point(major: origin.major + minMajor, minor: origin.minor + minMinor)
            let insetMinorDimension = minorDimension - minMinor - maxMinor
            
            let result = self.layoutAttributesWith(
                count: count,
                origin: insetOrigin,
                majorAxis: majorAxis,
                minorDimension: insetMinorDimension
            )

            return LayoutResult(layoutAttributes: result.layoutAttributes, finalOffset: result.finalOffset + maxMajor)
        }
    }
}

extension LayoutModuleType
{
    // MARK: - Transforms
    
    /**
    Produces a new layout module by translating the layout module.
    
    - parameter major: The major direction translation.
    - parameter minor: The minor direction translation.
    
    - returns: A new layout module, derived from the module this function was called on.
    */
    public func translate(major major: CGFloat = 0, minor: CGFloat = 0) -> LayoutModule
    {
        return LayoutModule { count, origin, majorAxis, minorDimension in
            self.layoutAttributesWith(
                count: count,
                origin: Point(major: origin.major + major, minor: origin.minor + minor),
                majorAxis: majorAxis,
                minorDimension: minorDimension
            )
        }
    }
}
