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
    
    The module will use the maximum number of rows or columns (depending on the major axis) that will match the
    `minimumMajorDimension` and `padding` constraints, keeping the actual column width as close to
    `minimumMajorDimension` as possible.
    
    - parameter minimumMinorDimension: The minimum minor dimension of each row/column.
    - parameter padding:               The padding between each row and column.
    - parameter aspectRatio:           The aspect ratio, minor dimension over major dimension.
    */
    public static func grid(
        minimumMinorDimension minimumMinorDimension: CGFloat,
        padding: Size,
        aspectRatio: CGFloat = 1)
        -> LayoutModule
    {
        return LayoutModule { count, origin, majorAxis, minorDimension in
            // calculate the number of columns and width of each column
            let (columnCount, cellMinor) = calculateColumns(
                minimum: minimumMinorDimension,
                spacing: padding.minor,
                total: minorDimension
            )
            
            let cellMajor = cellMinor / aspectRatio

            let attributes = (0..<count).map({ index -> LayoutAttributes in
                let majorIndex = index / columnCount, minorIndex = index % columnCount

                return LayoutAttributes(frame: Rect(
                    origin: Point(
                        major: origin.major + (cellMajor + padding.major) * CGFloat(majorIndex),
                        minor: origin.minor + (cellMinor + padding.minor) * CGFloat(minorIndex)
                    ),
                    size: Size(
                        major: cellMajor,
                        minor: cellMinor
                    )
                ))
            })
            
            return LayoutResult(
                layoutAttributes: attributes,
                finalOffset: (attributes.last?.frame).map({
                    frame in frame.origin.major + frame.size.major
                }) ?? origin.major
            )
        }
    }
}
