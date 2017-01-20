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
    // MARK: - Conditional Major Axis

    /**
     Creates a layout module that uses one layout module when laying out on one major axis, and a different layout
     module when laying out on the other major axis.

     - parameter horizontal: The layout module to use for a horizontal major axis.
     - parameter vertical:   The layout module to use for a vertical major axis.
     */
    public static func forMajorAxis(horizontal: LayoutModuleType, vertical: LayoutModuleType) -> LayoutModule
    {
        return LayoutModule { count, origin, majorAxis, minorDimension in
            let module = majorAxis == .horizontal ? horizontal : vertical

            return module.layoutAttributesWith(
                count: count,
                origin: origin,
                majorAxis: majorAxis,
                minorDimension: minorDimension
            )
        }
    }
}
