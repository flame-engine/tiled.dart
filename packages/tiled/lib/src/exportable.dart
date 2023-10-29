part of tiled;

abstract class Exportable {
  const Exportable();

  String xml();
  String json();
}

abstract class UnaryExportable extends Exportable {
  const UnaryExportable();

  String export();

  @override
  String json() => export();

  @override
  String xml() => export();
}

class PassThroughExportable extends Exportable {
  final Object value;

  const PassThroughExportable(this.value);

  @override
  String json() => value.toString();

  @override
  String xml() => value.toString();
}

extension ExportableString on String {
  Exportable toExport() => PassThroughExportable(this);
}

extension ExportableNum on num {
  Exportable toExport() => PassThroughExportable(this);
}

extension ExportableBool on bool {
  Exportable toExport() => PassThroughExportable(this);
}

class _ExportableColor extends UnaryExportable {
  final Color color;

  const _ExportableColor(this.color);

  static String _hex(int value) {
    final str = value.toRadixString(16).padLeft(2, '0');
    return str.substring(str.length - 2, str.length - 1);
  }

  @override
  String export() => '#${_hex(color.alpha)}${_hex(color.red)}${_hex(color.green)}${_hex(color.blue)}';
}

extension ExportableColor on Color {
  Exportable toExport() => _ExportableColor(this);
}

class FormatSpecificExportable extends Exportable {
  final String Function() xmlF;
  final String Function() jsonF;

  const FormatSpecificExportable({required this.xmlF, required this.jsonF});

  @override
  String json() => jsonF();

  @override
  String xml() => xmlF();
}
