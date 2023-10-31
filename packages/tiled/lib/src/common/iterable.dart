part of tiled;

extension Grouping<V> on Iterable<V> {
  Map<K, List<V>> groupBy<K>(K Function(V value) key) {
    final out = <K, List<V>>{};
    for (final v in this) {
      final k = key(v);
      if (!out.containsKey(k)) {
        out[k] = [v];
      } else {
        out[k]!.add(v);
      }
    }

    return out;
  }
}