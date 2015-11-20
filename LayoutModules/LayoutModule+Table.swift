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
    Arranges cells in vertical rows, determining the height of each dynamically with a function.
    
    - parameter verticalPadding: The padding between each row. This padding is not applied before the first row, or
                                 after the last row. For top or bottom padding, the `inset` function can be used.
    - parameter calculateHeight: A function to calculate the height of each cell, which will receive the parameters
                                 `index`, the current index within the section, and `width`, the width of the layout
                                 module.
    */
    public static func dynamicTable(
        verticalPadding verticalPadding: CGFloat = 0,
        calculateHeight: CalculateHeight)
        -> LayoutModule
    {
        return LayoutModule { attributes, origin, width in
            var y = origin.y
            
            for index in (0..<(attributes.count))
            {
                let height = calculateHeight(index: index, width: width)
                attributes[index].frame = CGRect(x: origin.x, y: y, width: width, height: height)
                
                y += height + verticalPadding
            }
            
            return y - verticalPadding
        }
    }
    
    /**
     Arranges cells in vertical rows.
     
     - parameter verticalPadding: The padding between each row. This padding is not applied before the first row, or
                                  after the last row. For top or bottom padding, the `inset` function can be used.
     - parameter rowHeight:       The height of each row.
     */
    public static func table(verticalPadding verticalPadding: CGFloat = 0, rowHeight: CGFloat) -> LayoutModule
    {
        return dynamicTable(verticalPadding: verticalPadding, calculateHeight: { _ in rowHeight })
    }
}
