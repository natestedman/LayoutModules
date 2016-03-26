# LayoutModules

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Build Status](https://travis-ci.org/natestedman/LayoutModules.svg?branch=master)](https://travis-ci.org/natestedman/LayoutModules)
[![License](https://img.shields.io/badge/license-Creative%20Commons%20Zero%20v1.0%20Universal-blue.svg)](https://creativecommons.org/publicdomain/zero/1.0/)

Provides `LayoutModulesCollectionViewLayout`, which uses a value of type `LayoutModuleType` for each section to build a stacked vertical or horizontal collection view layout.

## Major and Minor Axes
So that layout modules can be agnostic with respect to vertical and horizontal collection view scrolling, geometry is represented in terms of a major and minor axis. The major axis scrolls, and the minor axis does not.

## Using the Collection View Layout
To use `LayoutModulesCollectionViewLayout`, a value must be set for the `moduleForSection` property:

    public var moduleForSection: ((section: Int) -> LayoutModuleType)?

A convenience initializer is provided to perform this:

    public convenience init(majorAxis: Axis, moduleForSection: (section: Int) -> LayoutModuleType)

The `moduleForSection` function will receive each section index of the collection view as a parameter, and should return the layout module for that section.

## Built-in Layout Modules
The modules provided by the framework are implemented as static functions of the `LayoutModule` type.

### Dynamic Table
    LayoutModule.dynamicTable(padding:calculateMajorDimension:)

Stacks each item in the major direction, using the `calculateMajorDimension` to determine the width or height of each column or row. Additionally, a fixed amount of padding is placed between each cell.

### Table
    LayoutModule.table(majorDimension:padding:)

Stacks each item in the major direction, using the fixed `majorDimension` and `padding`.

### Grid
    LayoutModule.grid(minimumMinorDimension:padding:aspectRatio:)

Arranges the layout modules in a grid, according to the `minimumMinorDimension`, `padding`, and `aspectRatio` values. The number of rows or columns is the maximum possible.

### Masonry
    LayoutModule.masonry(minimumMinorDimension:padding:calculateMajorDimension:)

Builds a masonry-style layout, according to the `minimumMinorDimension` and `padding` values, then using `calculateMajorDimension` to determine the major dimension of each item. The number of rows or columns is the maximum possible.

## Custom Layout Modules
Custom layout modules can be created by implementing `LayoutModuleType`, but in most cases, initializing or extending `LayoutModule` should be sufficient.

`LayoutModule` can be initialized with a function taking these parameters:

- `count`: the number of items in the section.
- `origin`: the current layout origin. This is determined by the final offsets of the previous layout modules.
- `majorAxis`: the major axis for the layout, allowing different behavior to be used for vertical and horizontal layouts.
- `minorDimension`: the minor dimension of the layout module's content.

The function will return a result value, which contains the layout attribute values and the major offset value for the bottom of the section, in absolute terms.

## Transformations
All `LayoutModuleType` values can be inset with the `inset(minMajor:maxMajor:minMinor:maxMinor:)` function. This allows modules to be padded from the collection view edges or from each other, without supporting this directly in the layout functions.

## Example
A simple example project is provided in the `Example` directory.

## Documentation
If necessary, install `jazzy`:

    gem install jazzy
   
Then run:

    make docs

To generate HTML documentation in the `Documentation` subdirectory.

## Installation

Add:

    github "natestedman/LayoutModules"

To your `Cartfile`.
