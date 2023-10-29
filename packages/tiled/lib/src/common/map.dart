extension Null<K, V> on Map<K, V?> {
  Map<K, V> nonNulls() => {for (final e in entries.where((e) => e.value is V)) e.key : e.value as V};
}