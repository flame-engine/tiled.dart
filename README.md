# Tiled Dart

[![Pub](https://img.shields.io/pub/v/tiled.svg?style=popout)](https://pub.dartlang.org/packages/tiled) ![CI](https://github.com/flame-engine/tiled.dart/workflows/CI/badge.svg?branch=master&event=push) [![Discord](https://img.shields.io/discord/509714518008528896.svg)](https://discord.gg/pxrBmy4)

A Dart Tiled library.

## Install from Dart Pub Repository

Include the following in your `pubspec.yaml`:

```yaml
    dependencies:
      tiled: 0.4.0
```

## Usage

Import the package like this:

```dart
    import 'package:tiled/tiled.dart'
```

Load a TMX file into a string by any means, and then pass the string to TileMapParser.parseXml():

```dart
    final String tmxBody = /* ... */;
    final TiledMap mapTmx = TileMapParser.parseTmx(tmxBody);
```


Alternatively load a json file.

```dart
    final String jsonBody = /* ... */;
    final TiledMap mapTmx = TileMapParser.parseJson(jsonBody);
```


