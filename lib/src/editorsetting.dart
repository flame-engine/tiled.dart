part of tiled;

class Editorsetting {
  Chunk chunksize;
  Export export;

  Editorsetting.fromXml(XmlNode xmlElement) {
    xmlElement.children.whereType<XmlElement>().forEach((XmlElement element) {
      switch (element.name.local) {
        case 'chunksize':
          chunksize = Chunk.fromXml(element);
          break;
        case 'export':
          export = Export.fromXml(element);
          break;
      }
    });

  }

  Editorsetting.fromJson(Map<String, dynamic> json) {
    chunksize = json['chunksize'] != null
        ? Chunk.fromJson(json['chunksize'])
        : null;
    export =
        json['export'] != null ? Export.fromJson(json['export']) : null;
  }
}
