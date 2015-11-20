# LayoutModules

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Build Status](https://travis-ci.org/natestedman/LayoutModules.svg?branch=master)](https://travis-ci.org/natestedman/LayoutModules)
[![License](https://img.shields.io/badge/license-Creative%20Commons%20Zero%20v1.0%20Universal-blue.svg)](https://creativecommons.org/publicdomain/zero/1.0/)

Provides `LayoutModulesCollectionViewLayout`, which uses a value of type `LayoutModuleType` for each section to build a stacked vertical collection view layout.

## Using the Layout
To use `LayoutModulesCollectionViewLayout`, a value must be set for the `moduleForSection` property:

    public var moduleForSection: ((section: Int) -> LayoutModuleType)?

A convenience initializer is provided to perform this:

    public convenience init(moduleForSection: (section: Int) -> LayoutModuleType)

The `moduleForSection` function will receive each section index of the collection view as a parameter, and should return the layout module for that section.

## Built-in Layout Modules
The modules provided by the framework are implemented as static functions of the `LayoutModule` type.

### Dynamic Table
    LayoutModule.dynamicTable(verticalPadding:calculateHeight:)

Stacks each item vertically, using the `calculateHeight` to determine the height of each row. Additionally, a fixed amount of padding is placed between each row.

### Table
    LayoutModule.table(verticalPadding:rowHeight:)

Stacks each item vertically, using the fixed `rowHeight` and `verticalPadding`.

### Grid
    LayoutModule.grid(minimumWidth:padding:aspectRatio:)

Arranges the layout modules in a grid, according to the `minimumWidth`, `padding`, and `aspectRatio` values. The number of columns is the maximum possible.

### Masonry
    LayoutModule.masonry(minimumWidth:padding:calculateHeight:)

Builds a masonry-style layout, according to the `mimimumWidth` and `padding` values, then using `calculateHeight` to determine the height of each item. The number of columns is the maximum possible.

## Custom Layout Modules
Custom layout modules can be created by implementing `LayoutModuleType`, but in most cases, initializing or extending `LayoutModule` should be sufficient.

`LayoutModule` can be initialized with a function taking these parameters:

- `attributes`: an array of `UICollectionViewLayoutAttributes` objects, which have been initialized for the appropriate index paths. The function should update these with the correct values.
- `origin`: the current layout origin. This is determined by the vertical offsets of the previous layout modules.
- `width`: the width of the layout module's content.

The function should return the Y offset value for the bottom of the section, in absolute terms.

## Transformations
All `LayoutModuleType` values can be inset with the `inset(top:left:bottom:right:)` and `inset(insets:)` functions. This allows modules to be padded from the edges or from each other, without supporting this directly in the layout functions.

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
