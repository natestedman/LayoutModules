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

// MARK: - Axes

/// The possible major (scrolling) and minor (non-scrolling) axes for a collection view.
public enum Axis
{
    /// The horizontal axis.
    case horizontal

    /// The vertical axis.
    case vertical
}

// MARK: - Points

/// An axis-agnostic point structure.
public struct Point
{
    // MARK: - Initialization

    /**
     Initializes a point structure.

     - parameter major: The major coordinate of the point.
     - parameter minor: The minor coordinate of the point.
     */
    public init(major: CGFloat, minor: CGFloat)
    {
        self.major = major
        self.minor = minor
    }

    /**
     Initializes a point structure from a Core Graphics point.

     - parameter CGPoint:   A Core Graphics point.
     - parameter majorAxis: The major axis to use.
     */
    public init(CGPoint: CoreGraphics.CGPoint, majorAxis: Axis)
    {
        switch majorAxis
        {
        case .horizontal:
            self = Point(major: CGPoint.x, minor: CGPoint.y)
        case .vertical:
            self = Point(major: CGPoint.y, minor: CGPoint.x)
        }
    }

    // MARK: - Coordinates

    /// The major coordinate of the point.
    var major: CGFloat

    /// The minor coordinate of the point.
    var minor: CGFloat
}

extension Point
{
    // MARK: - Core Graphics Integration

    /**
     Converts the axis-agnostic point to a Core Graphics point.

     - parameter majorAxis: The major axis to use.
     */
    public func CGPoint(majorAxis: Axis) -> CoreGraphics.CGPoint
    {
        switch majorAxis
        {
        case .horizontal:
            return CoreGraphics.CGPoint(x: major, y: minor)
        case .vertical:
            return CoreGraphics.CGPoint(x: minor, y: major)
        }
    }
}

// MARK: - Sizes

/// An axis-agnostic size structure.
public struct Size
{
    // MARK: - Initialization

    /**
     Initializes a size structure.

     - parameter major: The major dimension of the size.
     - parameter minor: The minor dimension of the size.
     */
    public init(major: CGFloat, minor: CGFloat)
    {
        self.major = major
        self.minor = minor
    }

    /**
     Initializes a size structure from a Core Graphics size.

     - parameter CGSize:    A Core Graphics size.
     - parameter majorAxis: The major axis to use.
     */
    public init(CGSize: CoreGraphics.CGSize, majorAxis: Axis)
    {
        switch majorAxis
        {
        case .horizontal:
            self = Size(major: CGSize.width, minor: CGSize.height)
        case .vertical:
            self = Size(major: CGSize.height, minor: CGSize.width)
        }
    }

    // MARK: - Coordinates

    /// The major dimension of the size.
    var major: CGFloat

    /// The minor dimension of the size.
    var minor: CGFloat
}

extension Size
{
    // MARK: - Core Graphics Integration

    /**
     Converts the axis-agnostic size to a Core Graphics size.

     - parameter majorAxis: The major axis to use.
     */
    public func CGSize(majorAxis: Axis) -> CoreGraphics.CGSize
    {
        switch majorAxis
        {
        case .horizontal:
            return CoreGraphics.CGSize(width: major, height: minor)
        case .vertical:
            return CoreGraphics.CGSize(width: minor, height: major)
        }
    }
}

// MARK: - Rects

/// An axis-agnostic rect structure.
public struct Rect
{
    // MARK: - Initialization

    /**
     Initializes a rect structure.

     - parameter origin: The origin of the rect.
     - parameter size:   The size of the rect.
     */
    public init(origin: Point, size: Size)
    {
        self.origin = origin
        self.size = size
    }

    /**
     Initializes a rect structure from a Core Graphics rect.

     - parameter CGRect:    A Core Graphics rect.
     - parameter majorAxis: The major axis to use.
     */
    public init(CGRect: CoreGraphics.CGRect, majorAxis: Axis)
    {
        self.init(
            origin: Point(CGPoint: CGRect.origin, majorAxis: majorAxis),
            size: Size(CGSize: CGRect.size, majorAxis: majorAxis)
        )
    }

    // MARK: - Components

    /// The origin of the rect.
    var origin: Point

    /// The size of the rect.
    var size: Size
}

extension Rect
{
    // MARK: - Core Graphics Integration

    /**
     Converts the axis-agnostic rect to a Core Graphics rect.

     - parameter majorAxis: The major axis to use.
     */
    public func CGRect(majorAxis: Axis) -> CoreGraphics.CGRect
    {
        return CoreGraphics.CGRect(
            origin: origin.CGPoint(majorAxis: majorAxis),
            size: size.CGSize(majorAxis: majorAxis)
        )
    }
}
