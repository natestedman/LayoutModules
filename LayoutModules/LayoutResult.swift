// LayoutModules
// Written in 2016 by Nate Stedman <nate@natestedman.com>
//
// To the extent possible under law, the author(s) have dedicated all copyright and
// related and neighboring rights to this software to the public domain worldwide.
// This software is distributed without any warranty.
//
// You should have received a copy of the CC0 Public Domain Dedication along with
// this software. If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.

import CoreGraphics

/// The result of a layout module for a specific section.
public struct LayoutResult
{
    // MARK: - Initialization

    /**
     Initializes a layout result.

     - parameter layoutAttributes: The layout attributes for this section.
     - parameter finalOffset:      The final offset, after this section.
     */
    public init(layoutAttributes: [LayoutAttributes], finalOffset: CGFloat)
    {
        self.layoutAttributes = layoutAttributes
        self.finalOffset = finalOffset
    }

    // MARK: - Properties

    /// The layout attributes for this section.
    public let layoutAttributes: [LayoutAttributes]

    /// The final offset, after this section.
    public let finalOffset: CGFloat
}
