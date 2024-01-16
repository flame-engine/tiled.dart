part of tiled;

abstract class Provider<T> {
  bool canProvide(String filename);

  T getSource(String filename);
  T? getCachedSource(String filename);
}

typedef ParserProvider = Provider<Parser>;
typedef ImagePathProvider = Provider<String>;