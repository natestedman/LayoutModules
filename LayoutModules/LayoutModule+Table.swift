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

extension LayoutModule
{
    // MARK: - Table Modules
    
    /**
    Arranges cells in rows along the major dimension, determining the major dimension of each dynamically.
    
    - parameter padding:                 The padding between each cell in the major dimension. This padding is not
                                         applied before the first cell, or after the last cell. For applying padding to
                                         those areas, the `inset` function can be used.
    - parameter calculateMajorDimension: A function to calculate the major dimension of each cell, which will receive
                                         the parameters `index`, the current index within the section, and
                                         `otherDimension`, the minor dimension of the layout module.
    */
    public static func dynamicTable(
        padding padding: CGFloat = 0,
        calculateMajorDimension: CalculateDimension)
        -> LayoutModule
    {
        return LayoutModule { count, origin, _, minorDimension in
            var offset = origin.major

            let attributes = (0..<count).map({ index -> LayoutAttributes in
                let majorDimension = calculateMajorDimension(index: index, otherDimension: minorDimension)

                let frame = Rect(
                    origin: Point(major: offset, minor: origin.minor),
                    size: Size(major: majorDimension, minor: minorDimension)
                )

                offset += majorDimension + padding

                return LayoutAttributes(frame: frame)
            })
            
            return LayoutResult(layoutAttributes: attributes, finalOffset: offset - padding)
        }
    }
    
    /**
     Arranges cells in vertical rows.
     
     - parameter majorDimension: The height of each row.
     - parameter padding:        The padding between each cell in the major dimension. This padding is not applied
                                 before the first cell, or after the last cell. For applying padding to those areas, the
                                 `inset` function can be used.
     */
    public static func table(majorDimension majorDimension: CGFloat, padding: CGFloat = 0) -> LayoutModule
    {
        return dynamicTable(padding: padding, calculateMajorDimension: { _ in majorDimension })
    }
}
