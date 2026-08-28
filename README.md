# Tiled Dart

[![Pub](https://img.shields.io/pub/v/tiled.svg?style=popout)](https://pub.dartlang.org/packages/tiled) [![cicd](https://github.com/flame-engine/tiled.dart/actions/workflows/cicd.yaml/badge.svg)](https://github.com/flame-engine/tiled.dart/actions/workflows/cicd.yaml) [![Discord](https://img.shields.io/discord/509714518008528896.svg)](https://discord.gg/pxrBmy4)

A Dart Tiled library.

## Install from Dart Pub Repository

To include the package as a dependency in your `pubspec.yaml`, run the following (or add it manually):

```sh
dart pub add tiled
```

## Usage

Import the package like this:

```dart
    import 'package:tiled/tiled.dart';
```

### Load Tmx Files

Load a TMX file into a string by any means, and then pass the string to `TiledMap.parseTmx()`:

```dart
    final String tmxBody = /* ... */;
    final TiledMap mapTmx = TiledMap.parseTmx(tmxBody);
```

### Load Json Files

Alternatively load a json file with `TiledMap.parseJson()`:

```dart
    final String jsonBody = /* ... */;
    final TiledMap mapJson = TiledMap.parseJson(jsonBody);
```

### External Files

If your map references external files, like external tilesets (`.tsx`) or object templates
(`.tx`), you have to pass one or more `ParserProvider`s that resolve these files. Every time the
parser encounters a reference to an external file, the first provider that `canProvide` the
referenced path is asked for a `Parser` of its contents through `getSource`.

The path is always relative to the map file, also for files referenced from other external files,
so a single provider can resolve any number of files, for example everything below a directory:

```dart
class DirectoryProvider extends ParserProvider {
  final String root;

  DirectoryProvider(this.root);

  @override
  bool canProvide(String path) => File('$root/$path').existsSync();

  @override
  Parser getSource(String path) {
    return Parser.fromString(File('$root/$path').readAsStringSync());
  }
}
```

`Parser.fromString` creates an `XmlParser` or a `JsonParser` depending on the contents. Every file
is requested at most once per parsed map.

The providers are passed to `parseTmx` or `parseJson`:

```dart
    final TiledMap mapTmx = TiledMap.parseTmx(
      tmxBody,
      providers: [DirectoryProvider('assets/tiles')],
    );
```

### Loading External Files Asynchronously

When the external files can only be loaded asynchronously, for example from an asset bundle, use
`TiledMap.fromString` instead. It parses either tmx or json and loads every referenced file, also
the ones referenced from other external files, with the given loader before returning the map:

```dart
    final TiledMap map = await TiledMap.fromString(
      contents,
      (path) => rootBundle.loadString('assets/tiles/$path'),
    );
```

### Implementation

For further information and more usage examples, please take a look at the examples in [flame_tiled](https://github.com/flame-engine/flame/tree/main/packages/flame_tiled).
