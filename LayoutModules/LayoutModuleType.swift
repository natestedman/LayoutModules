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
     Updates the layout attribute objects with layout information.
     
     - parameter attributes: The array of attributes to update.
     - parameter origin:     The origin of the module.
     - parameter width:      The width of the module.
     
     - returns: The new Y offset, used for the next layout module.
     */
    func prepareLayoutAttributes(attributes: [UICollectionViewLayoutAttributes], origin: CGPoint, width: CGFloat)
        -> CGFloat
}

extension LayoutModuleType
{
    // MARK: - Insets
    
    /**
    Produces a new layout module by insetting the layout module, with an edge insets value.
    
    - parameter insets: The edge insets.
    
    - returns: A new layout module, derived from the module this function was called on.
    */
    public func inset(insets: UIEdgeInsets) -> LayoutModule
    {
        return inset(top: insets.top, left: insets.left, bottom: insets.bottom, right: insets.right)
    }
    
    /**
     Produces a new layout module by insetting the layout module.
     
     All parameters are optional. If a parameter is omitted, that edge will not be inset.
     
     - parameter top:    The top inset.
     - parameter left:   The left inset.
     - parameter bottom: The bottom inset.
     - parameter right:  The right inset.
     
     - returns: A new layout module, derived from the module this function was called on.
     */
    public func inset(top top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) -> LayoutModule
    {
        return LayoutModule { attributes, origin, width in
            let insetOrigin = CGPoint(x: origin.x + left, y: origin.y + top)
            let insetWidth = width - left - right
            
            return self.prepareLayoutAttributes(attributes, origin: insetOrigin, width: insetWidth) + bottom
        }
    }
    
    // MARK: - Transforms
    
    /**
    Produces a new layout module by translating the layout module.
    
    - parameter x: The x translation.
    - parameter y: The y translation.
    
    - returns: A new layout module, derived from the module this function was called on.
    */
    public func translate(x x: CGFloat = 0, y: CGFloat = 0) -> LayoutModule
    {
        return LayoutModule { attributes, origin, width in
            self.prepareLayoutAttributes(
                attributes,
                origin: CGPoint(x: origin.x + x, y: origin.y + y),
                width: width
            )
        }
    }
}
