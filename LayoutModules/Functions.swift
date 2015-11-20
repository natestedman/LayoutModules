// LayoutModules
// Written in 2015 by Nate Stedman <nate@natestedman.com>
//
// To the extent possible under law, the author(s) have dedicated all copyright and
// related and neighboring rights to this software to the public domain worldwide.
// This software is distributed without any warranty.
//
// You should have received a copy of the CC0 Public Domain Dedication along with
// this software. If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.

import CoreGraphics

internal func calculateColumns(minimum minimum: CGFloat, spacing: CGFloat, total: CGFloat) -> (Int, CGFloat)
{
    var count = 1
    
    while minimum * CGFloat(count) + spacing * CGFloat(count - 1) < total
    {
        count++
    }
    
    count = max(count - 1, 1)
    
    return (count, round((total - CGFloat(count - 1) * spacing) / CGFloat(count)))
}
