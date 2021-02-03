part of tiled;

class Editorsetting {
  Chunksize chunksize;
  Export export;

  Editorsetting.fromXml(XmlNode xmlElement) {
    xmlElement.children.whereType<XmlElement>().forEach((XmlElement element) {
      switch (element.name.local) {
        case 'chunksize':
          chunksize = Chunksize.fromXml(element);
          break;
        case 'export':
          export = Export.fromXml(element);
          break;
      }
    });

  }

  Editorsetting.fromJson(Map<String, dynamic> json) {
    chunksize = json['chunksize'] != null
        ? Chunksize.fromJson(json['chunksize'])
        : null;
    export =
        json['export'] != null ? Export.fromJson(json['export']) : null;
  }
}
