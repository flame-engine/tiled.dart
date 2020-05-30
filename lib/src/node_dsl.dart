part of tiled;

class NodeDSL {
  XmlElement element;

  NodeDSL(this.element);

  static NodeDSL on(XmlElement element, Function fxn) {
    var node = new NodeDSL(element);
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

  _attr(String attrName) {
    return element.getAttribute(attrName);
  }

  _safely(String attrName, defaultValue, Function fxn) {
    String value = _attr(attrName);
    if (value != null) {
      return fxn(value);
    }
    return defaultValue;
  }
}
