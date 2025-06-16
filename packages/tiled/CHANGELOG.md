## 0.12.0

> Note: This release has breaking changes.

 - **REFACTOR**: Upgrade code style and dependencies ([#82](https://github.com/flame-engine/tiled.dart/issues/82)). ([581391cf](https://github.com/flame-engine/tiled.dart/commit/581391cf4b4e5a504b42324e353876e9e7afbb75))
 - **FIX**: Data section of Layers was null (when loading from JSON) ([#84](https://github.com/flame-engine/tiled.dart/issues/84)). ([00dbd13c](https://github.com/flame-engine/tiled.dart/commit/00dbd13c6c5bd7a6268ebec51c43c1bf9121f06a))
 - **FIX**: Fixed parsing of multiline text from ObjectGroup. ([#79](https://github.com/flame-engine/tiled.dart/issues/79)). ([7878381b](https://github.com/flame-engine/tiled.dart/commit/7878381b4333a4f04032d93a300f0c13ec6e1f11))
 - **FIX**: `ObjectAlignment` enum names ([#74](https://github.com/flame-engine/tiled.dart/issues/74)). ([628f1f6c](https://github.com/flame-engine/tiled.dart/commit/628f1f6cc89f6dd9b0a9cadcdd619549cf180e35))
 - **FEAT**: Adding a method to get any object in a map by its unique ID ([#75](https://github.com/flame-engine/tiled.dart/issues/75)). ([4faf43b4](https://github.com/flame-engine/tiled.dart/commit/4faf43b45002e19c8fdbf2af8dd09969bcf4781c))
 - **FEAT**: Omit TiledImage without source from TiledMap.tiledImages ([#68](https://github.com/flame-engine/tiled.dart/issues/68)). ([41c9439f](https://github.com/flame-engine/tiled.dart/commit/41c9439f9c0f1345b8b803b9b33d3a507e45bf1a))
 - **FEAT**: Add convenience method for getting images in each layer ([#66](https://github.com/flame-engine/tiled.dart/issues/66)). ([1d3043f7](https://github.com/flame-engine/tiled.dart/commit/1d3043f75dc59449e98c9f2f637141b8ac127508))
 - **BREAKING** **FEAT**: Dart SDK compatibility  ([#77](https://github.com/flame-engine/tiled.dart/issues/77)). ([5ffc8bf4](https://github.com/flame-engine/tiled.dart/commit/5ffc8bf4f99ffb1d08686856325b6f0f98760e26))

## 0.11.0

> Note: This release has breaking changes.

 - **REFACTOR**: Upgrade code style and dependencies ([#82](https://github.com/flame-engine/tiled.dart/issues/82)). ([581391cf](https://github.com/flame-engine/tiled.dart/commit/581391cf4b4e5a504b42324e353876e9e7afbb75))
 - **FIX**: Fixed parsing of multiline text from ObjectGroup. ([#79](https://github.com/flame-engine/tiled.dart/issues/79)). ([7878381b](https://github.com/flame-engine/tiled.dart/commit/7878381b4333a4f04032d93a300f0c13ec6e1f11))
 - **FIX**: `ObjectAlignment` enum names ([#74](https://github.com/flame-engine/tiled.dart/issues/74)). ([628f1f6c](https://github.com/flame-engine/tiled.dart/commit/628f1f6cc89f6dd9b0a9cadcdd619549cf180e35))
 - **FEAT**: Adding a method to get any object in a map by its unique ID ([#75](https://github.com/flame-engine/tiled.dart/issues/75)). ([4faf43b4](https://github.com/flame-engine/tiled.dart/commit/4faf43b45002e19c8fdbf2af8dd09969bcf4781c))
 - **FEAT**: Omit TiledImage without source from TiledMap.tiledImages ([#68](https://github.com/flame-engine/tiled.dart/issues/68)). ([41c9439f](https://github.com/flame-engine/tiled.dart/commit/41c9439f9c0f1345b8b803b9b33d3a507e45bf1a))
 - **FEAT**: Add convenience method for getting images in each layer ([#66](https://github.com/flame-engine/tiled.dart/issues/66)). ([1d3043f7](https://github.com/flame-engine/tiled.dart/commit/1d3043f75dc59449e98c9f2f637141b8ac127508))
 - **BREAKING** **FEAT**: Dart SDK compatibility  ([#77](https://github.com/flame-engine/tiled.dart/issues/77)). ([5ffc8bf4](https://github.com/flame-engine/tiled.dart/commit/5ffc8bf4f99ffb1d08686856325b6f0f98760e26))

## 0.10.2

 - **FIX**: `ObjectAlignment` enum names ([#74](https://github.com/flame-engine/tiled.dart/issues/74)). ([628f1f6c](https://github.com/flame-engine/tiled.dart/commit/628f1f6cc89f6dd9b0a9cadcdd619549cf180e35))
 - **FEAT**: Adding a method to get any object in a map by its unique ID ([#75](https://github.com/flame-engine/tiled.dart/issues/75)). ([4faf43b4](https://github.com/flame-engine/tiled.dart/commit/4faf43b45002e19c8fdbf2af8dd09969bcf4781c))
 - **FEAT**: Omit TiledImage without source from TiledMap.tiledImages ([#68](https://github.com/flame-engine/tiled.dart/issues/68)). ([41c9439f](https://github.com/flame-engine/tiled.dart/commit/41c9439f9c0f1345b8b803b9b33d3a507e45bf1a))
 - **FEAT**: Add convenience method for getting images in each layer ([#66](https://github.com/flame-engine/tiled.dart/issues/66)). ([1d3043f7](https://github.com/flame-engine/tiled.dart/commit/1d3043f75dc59449e98c9f2f637141b8ac127508))

## 0.10.1

 - **FEAT**: Add `imageRect` for `Tile` ([#64](https://github.com/flame-engine/tiled.dart/issues/64)). ([33d99b70](https://github.com/flame-engine/tiled.dart/commit/33d99b70e9c0c9b11483d9a25abfc1375869c87f))

## 0.10.0

> Note: This release has breaking changes.

 - **BREAKING** **FIX**: support parsing empty tile terrain values ([#61](https://github.com/flame-engine/tiled.dart/issues/61)). ([3c75b03a](https://github.com/flame-engine/tiled.dart/commit/3c75b03a2d122e7ab5fe22bdf102755b18a26130))
 - **BREAKING** **FEAT**: turning List<Property> into CustomProperties ([#55](https://github.com/flame-engine/tiled.dart/issues/55)). ([51d59ec5](https://github.com/flame-engine/tiled.dart/commit/51d59ec585e2913decabfc48c333cba4a20df9c4))

## 0.9.0

> Note: This release has breaking changes.

 - **BREAKING** **CHORE**: Introduce Melos and bump versions ([#53](https://github.com/flame-engine/tiled.dart/issues/53)). ([9222d018](https://github.com/flame-engine/tiled.dart/commit/9222d018258fffbff54c4ab3d2c441019d48d234))

## [Next]
* Adding support for searching `Group` layer children when using `map.layerByName`.
* Add parser support for Tiled hex colors as `ui.Color`
* BREAKING CHANGE: re-named string color fields to `colorHex` such as `layer.tintColorHex` and 
  added a new `color` field paired with each `colorHex` field of type `ui.Color`.

## 0.8.4
* Adding "class" attribute for Tiled 1.9's Unified Custom Types:
    * On `Tile` accessible as `class_` or `type`, backwards compatible with "type" property 
    * On `Layer` accessible as `class_`, works on all kinds of layers (tile, object, group, image)
    * (since 0.8.2) On `Object` accessible as `class_` or `type`,
      backwards compatible with "type" property
* Add support for `repeatX` and `repeatY` on `ImageLayer`
* Fixing bug causing XML maps to be parsed with layers in the wrong order

## 0.8.3
* Downgrade meta dependency

## 0.8.2
* Add support for class, which is replacing type in tiled 1.9

## 0.8.1
* Possibility to parse string content of a tilemap in `TiledMap`

## 0.8.0
* Possibility to use multiple external tilesets (#37)
* Support in `parseTmx` for CSV-formatted files (#36)

## 0.7.3
* tileset parser fix for ObjectGroup

## 0.7.2
* Fix localGid bug

## 0.7.1
* Expose Parser

## 0.7.0
* Adds JSON support
* Adds Null-safety support
* Improve and refactor codebase

## 0.6.0
* Fixes bug with int points instead of double for objects.

## 0.5.0

* Fixes bug with inconsistent indexes crashes for rectangular maps.
* Changes indexing of `tiles` so that tiles[x] returns a line (so tiles[y][x]).

## 0.4.0

* Added typed properties support and properties for TileMap and Layer
* Added support for rotated tiles
* Some small API improvements (breaking)
* Added linter and formatter and tests to build

## 0.3.0

* `Layer` using 2d list store layer's `_tiles`,useful for get tile by coordinate `x,y`
* `Layer` using `px,px,x,y` instead of just `x,y`(pixel)
* add `width`,`height` to TileMap

## 0.11.7

* `<object />` tags are now parsed for their `type` attribute

## 0.11.5

* Added support for gzip compression
