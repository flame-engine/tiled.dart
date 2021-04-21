part of tiled;

class EditorSetting {
  ChunkSize chunkSize;
  Export export;

  EditorSetting.fromXml(XmlNode xmlElement) {
    xmlElement.children.whereType<XmlElement>().forEach((XmlElement element) {
      switch (element.name.local) {
        case 'chunksize':
          chunkSize = ChunkSize.fromXml(element);
          break;
        case 'export':
          export = Export.fromXml(element);
          break;
      }
    });
  }

  EditorSetting.fromJson(Map<String, dynamic> json) {
    chunkSize = json['chunksize'] != null
        ? ChunkSize.fromJson(json['chunksize'])
        : null;
    export = json['export'] != null ? Export.fromJson(json['export']) : null;
  }
}
