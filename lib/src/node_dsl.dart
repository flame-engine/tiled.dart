part of tiled;

class NodeDSL {
  XmlElement element;

  NodeDSL(this.element);

  static NodeDSL on(XmlElement element, Function(NodeDSL) fxn) {
    final node = NodeDSL(element);
    fxn(node);
    return node;
  }

  String strOr(String attrName, String defaultValue) {
    return _safely(attrName, defaultValue, (val) => val);
  }

  int intOr(String attrName, int defaultValue) {
    return _safely(attrName, defaultValue, (val) => int.parse(val));
  }

  double doubleOr(String attrName, double defaultValue) {
    return _safely(attrName, defaultValue, (v) => double.parse(v));
  }

  bool boolOr(String attrName, bool defaultValue) {
    return _safely(attrName, defaultValue, (v) => v == "1");
  }

  String _attr(String attrName) {
    return element.getAttribute(attrName);
  }

  T _safely<T>(String attrName, T defaultValue, T Function(String) fxn) {
    final value = _attr(attrName);
    if (value != null) {
      return fxn(value);
    }
    return defaultValue;
  }
}
