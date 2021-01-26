import 'package:tiled/src/json/chunkjson.dart';
import 'package:tiled/src/json/exportjson.dart';
import 'package:xml/src/xml/nodes/node.dart';
import 'package:xml/xml.dart';

class EditorsettingJson {
  ChunkJson chunksize;
  ExportJson export;

  EditorsettingJson({this.chunksize, this.export});

  EditorsettingJson.fromXML(XmlNode xmlElement) {
    xmlElement.children.whereType<XmlElement>().forEach((XmlElement element) {
      switch (element.name.local) {
        case 'chunksize':
          chunksize = ChunkJson.fromXML(element);
          break;
        case 'export':
          export = ExportJson.fromXML(element);
          break;
      }
    });

  }

  EditorsettingJson.fromJson(Map<String, dynamic> json) {
    chunksize = json['chunksize'] != null
        ? ChunkJson.fromJson(json['chunksize'])
        : null;
    export =
        json['export'] != null ? ExportJson.fromJson(json['export']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (chunksize != null) {
      data['chunksize'] = chunksize.toJson();
    }
    if (export != null) {
      data['export'] = export.toJson();
    }
    return data;
  }
}
