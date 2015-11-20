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
    // MARK: - Grid Modules
    
    /**
    Creates a grid-based layout module.
    
    The module will use the maximum number of columns that will match the `minimumWidth` and `padding` constraints,
    keeping the actual column width as close to `minimumWidth` as possible.
    
    - parameter minimumWidth: The minimum width of each column.
    - parameter padding:      The padding between each row and column.
    - parameter aspectRatio:  The aspect ratio, width over height.
    */
    public static func grid(
        minimumWidth minimumWidth: CGFloat,
        padding: CGSize,
        aspectRatio: CGFloat = 1)
        -> LayoutModule
    {
        return LayoutModule { attributes, origin, width in
            // calculate the number of columns and width of each column
            let (columnCount, cellWidth) = calculateColumns(
                minimum: minimumWidth,
                spacing: padding.width,
                total: width
            )
            
            let cellHeight = cellWidth / aspectRatio
            
            for index in 0..<(attributes.count)
            {
                let row = index / columnCount, column = index % columnCount
                
                attributes[index].frame = CGRect(
                    x: origin.x + (cellWidth + padding.width) * CGFloat(column),
                    y: origin.y + CGFloat(row) * (cellHeight + padding.height),
                    width: cellWidth,
                    height: cellHeight
                )
            }
            
            return (attributes.last?.frame).map(CGRectGetMaxY) ?? origin.y
        }
    }
}
