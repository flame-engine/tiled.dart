import 'dart:io';

import 'package:tiled/tiled.dart';

/// Provides every file in the fixtures directory, or only the ones in [files]
/// if given.
class FixtureProvider extends ParserProvider {
  static const directory = './test/fixtures';

  final Set<String>? files;
  final List<String> requestedPaths = [];

  FixtureProvider({this.files});

  static String read(String path) {
    return File('$directory/$path').readAsStringSync();
  }

  @override
  bool canProvide(String path) {
    if (files != null) {
      return files!.contains(path);
    }
    return File('$directory/$path').existsSync();
  }

  @override
  Parser getSource(String path) {
    requestedPaths.add(path);
    return Parser.fromString(read(path));
  }
}
