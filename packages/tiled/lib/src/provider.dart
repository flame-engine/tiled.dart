import 'package:tiled/tiled.dart';

abstract class Provider<T> {
  bool canProvide(String path);

  T getSource(String path);
  T? getCachedSource(String path);
}

typedef ParserProvider = Provider<Parser>;
typedef ImagePathProvider = Provider<String>;
