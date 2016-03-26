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
    
    - parameter minimumMinorDimension:   The minimum minor dimension of each row or column.
    - parameter padding:                 The padding for each row or column.
    - parameter calculateMajorDimension: A function to calculate the major dimension of each cell, given the minor
                                         dimension and current index.
    */
    public static func masonry(
        minimumMinorDimension minimumMinorDimension: CGFloat,
        padding: Size,
        calculateMajorDimension: CalculateDimension)
        -> LayoutModule
    {
        return LayoutModule { count, origin, _, minorDimension in
            // calculate the number of columns and width of each column
            let (minorCount, cellMinor) = calculateColumns(
                minimum: minimumMinorDimension,
                spacing: padding.minor,
                total: minorDimension
            )
            
            // keep track of the current major offset for each row or column
            var offsets = Array(count: minorCount, repeatedValue: origin.major)

            let attributes = (0..<count).map({ index -> LayoutAttributes in
                // calculate the height of this masonry item
                let cellMajor = calculateMajorDimension(index: index, otherDimension: cellMinor)
                
                // find the shortest column
                let index = (0..<minorCount).minElement({ lhs, rhs in offsets[lhs] < offsets[rhs] }) ?? 0
                
                // update the layout attribute frame
                let frame = Rect(
                    origin: Point(
                        major: offsets[index],
                        minor: origin.minor + (cellMinor + padding.minor) * CGFloat(index)
                    ),
                    size: Size(major: cellMajor, minor: cellMinor)
                )
                
                // offset the column height
                offsets[index] += cellMajor + padding.major

                return LayoutAttributes(frame: frame)
            })
            
            return LayoutResult(
                layoutAttributes: attributes,
                finalOffset: (offsets.maxElement() ?? padding.major) - padding.major
            )
        }
    }
}
