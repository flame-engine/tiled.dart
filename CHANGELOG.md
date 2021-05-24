## [next]

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
