import 'package:test/test.dart';
import 'package:xml/xml.dart';

class XmlDeepMatcher extends Matcher {
  final XmlElement expected;

  XmlDeepMatcher(this.expected);
  XmlDeepMatcher.parse(String xml)
      : expected = XmlDocument.parse(xml).rootElement..normalize();

  @override
  Description describe(Description description) =>
      description..add(expected.toString());

  @override
  bool matches(dynamic item, Map matchState) {
    if (item is! XmlElement) return false;
    return _match(item, expected);
  }

  bool _match(XmlElement a, XmlElement b) {
    return a.localName == b.localName &&
        _deepIterable(
          a.attributes,
          b.attributes,
          (a, b) =>
              a.localName == b.localName &&
              a.attributeType.name == b.attributeType.name &&
              a.value.trim() == b.value.trim(),
        ) &&
        _deepIterable(_cleanNodes(a.children), _cleanNodes(b.children), (a, b) {
          if (a.runtimeType != b.runtimeType) return false;

          if (a is XmlText) {
            return a.value.trim() == b.value!.trim();
          } else if (a is XmlElement) {
            return _match(a, b as XmlElement);
          } else {
            return false;
          }
        });
  }

  bool _deepIterable<T>(
    Iterable<T> a,
    Iterable<T> b,
    bool Function(T a, T b) equals,
  ) {
    if (a.length != b.length) return false;
    return a.every((aa) => b.any((bb) => equals(aa, bb)));
  }

  Iterable<XmlNode> _cleanNodes(Iterable<XmlNode> list) => list.where(
        (e) =>
            e is! XmlCDATA &&
            e is! XmlComment &&
            e is! XmlDeclaration &&
            e is! XmlProcessing,
      );
}
