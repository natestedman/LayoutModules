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
    // MARK: - Masonry Modules
    
    /**
    Creates a masonry layout.
    
    - parameter minimumWidth:    The minimum width of each column.
    - parameter padding:         The padding for each column.
    - parameter calculateHeight: A function to calculate the height of each cell, given the column width and current
                                 index.
    */
    public static func masonry(
        minimumWidth minimumWidth: CGFloat,
        padding: CGSize,
        calculateHeight: CalculateHeight)
        -> LayoutModule
    {
        return LayoutModule { attributes, origin, width in
            // calculate the number of columns and width of each column
            let (columnCount, cellWidth) = calculateColumns(
                minimum: minimumWidth,
                spacing: padding.width,
                total: width
            )
            
            // keep track of the current y offset for each column
            var columns = Array(count: columnCount, repeatedValue: origin.y)
            
            for index in 0..<(attributes.count)
            {
                // calculate the height of this masonry item
                let height = calculateHeight(index: index, width: cellWidth)
                
                // find the shortest column
                let column = (0..<columnCount).minElement({ lhs, rhs in columns[lhs] < columns[rhs] }) ?? 0
                
                // update the layout attribute frame
                attributes[index].frame = CGRect(
                    x: origin.x + (cellWidth + padding.width) * CGFloat(column),
                    y: columns[column],
                    width: cellWidth,
                    height: height
                )
                
                // offset the column height
                columns[column] += height + padding.height
            }
            
            return (columns.maxElement() ?? padding.height) - padding.height
        }
    }
}
