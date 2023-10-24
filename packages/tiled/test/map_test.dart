import 'package:test/test.dart';
import 'package:tiled/tiled.dart';

void main() {
  //GID is 1-based
  group('Map.getTileByGID', () {
    late TiledMap map;
    setUp(() {
      map = TiledMap(
        width: 24,
        height: 24,
        tileWidth: 8,
        tileHeight: 8,
        tilesets: [
          Tileset(
            name: 'TileSet_1',
            firstGid: 1,
            columns: 1,
            tileCount: 2,
            tiles: [
              Tile(localId: 0),
              Tile(localId: 1),
            ],
          ),
          Tileset(
            name: 'TileSet_2',
            firstGid: 3,
            columns: 1,
            tileCount: 2,
            tiles: [
              Tile(localId: 0),
              Tile(localId: 1),
            ],
          ),
          Tileset(
            name: 'TileSet_3',
            firstGid: 5,
            columns: 2,
            tileCount: 2,
            tiles: [
              Tile(localId: 0),
              Tile(
                localId: 2,
                properties: CustomProperties({
                  'name': StringProperty(
                    name: 'name',
                    value: 'tile2-prop-value',
                  ),
                }),
              ),
            ],
          ),
        ],
      );
    });

    test('returns an empty Tile if GID is 0', () {
      final tile = map.tileByGid(0);
      expect(tile?.isEmpty, isTrue);
    });

    test('GID = 4 && with tileId = 2', () {
      // TileSet_3 - first gid = 5
      // Tile 2 => gid = 5 + 2 = 6
      final tile = map.tileByGid(7);

      expect(tile?.localId, equals(2));
      expect(tile?.properties['name'], isA<StringProperty>());
      expect(
        tile?.properties.getValue<String>('name'),
        equals('tile2-prop-value'),
      );
    });
  });

  group('Map.getTileByLocalID', () {
    late TiledMap map;
    final tileset = Tileset(
      name: 'Humans',
      firstGid: 1,
      columns: 32,
      tileCount: 64 * 32,
    );
    setUp(() {
      map = TiledMap(
        width: 100,
        height: 100,
        tileWidth: 16,
        tileHeight: 16,
        tilesets: [tileset],
      );
    });

    test('there should be no tile with a Gid of 0', () {
      expect(map.tileByGid(0)?.localId, equals(-1));
    });

    group('returns a tile', () {
      late Tile tile;
      setUp(() => tile = map.tileByLocalId('Humans', 0)!);

      test('with the expected local tile ID', () {
        expect(tile.localId, equals(0));
      });
    });
  });

  group('Map.getTileByPhrase', () {
    late TiledMap map;
    final tileset = Tileset(
      name: 'Humans',
      firstGid: 1,
      columns: 32,
      tileCount: 64 * 32,
    );
    setUp(() {
      map = TiledMap(
        width: 100,
        height: 100,
        tileWidth: 16,
        tileHeight: 16,
        tilesets: [tileset],
      );
    });

    test('errors if tile phrase is not in the correct format', () {
      expect(
        () => map.tileByPhrase('Nonexistant Tile'),
        throwsArgumentError,
      );
    });

    test('errors if tileset is not present', () {
      expect(
        () => map.tileByPhrase('Nonexistant Tile|0'),
        throwsArgumentError,
      );
    });

    test('errors if tile id is not a parsable integer', () {
      expect(() => map.tileByPhrase('Humans|cupcake'), throwsArgumentError);
    });

    group('returns a tile', () {
      late Tile tile;
      setUp(() => tile = map.tileByPhrase('Humans|0')!);

      test('with the expected local tile ID', () {
        expect(tile.localId, equals(0));
      });
    });
  });

  group('Map.collectImagesInLayer', () {
    late TiledMap map;
    setUp(() {
      map = TiledMap(
        width: 2,
        height: 2,
        tileWidth: 8,
        tileHeight: 8,
        layers: [
          TileLayer(
            name: 'tile layer 1',
            width: 2,
            height: 2,
            data: [1, 0, 2, 0],
          ),
          Group(
            name: 'group layer 1',
            layers: [
              TileLayer(
                name: 'group - tile layer 1',
                width: 2,
                height: 2,
                data: [1, 2, 3, 0],
              ),
              TileLayer(
                name: 'group - tile layer 2',
                width: 2,
                height: 2,
                data: [5, 0, 0, 0],
              ),
            ],
          ),
          ImageLayer(
            name: 'image layer 1',
            image: const TiledImage(source: 'image_layer.png'),
            repeatX: false,
            repeatY: false,
          ),
          ObjectGroup(name: 'object layer 1', objects: []),
          TileLayer(
            name: 'tile layer 3 (empty)',
            width: 2,
            height: 2,
            data: [0, 0, 0, 0],
          ),
        ],
        tilesets: [
          Tileset(
            name: 'TileSet_1',
            image: const TiledImage(source: 'tileset_1.png'),
            firstGid: 1,
            columns: 1,
            tileCount: 2,
            tiles: [
              Tile(localId: 0),
              Tile(localId: 1),
            ],
          ),
          Tileset(
            name: 'TileSet_2',
            image: const TiledImage(source: 'tileset_2.png'),
            firstGid: 3,
            columns: 1,
            tileCount: 2,
            tiles: [
              Tile(localId: 0),
              Tile(localId: 1),
            ],
          ),
          Tileset(
            name: 'TileSet_3',
            image: const TiledImage(source: 'tileset_3.png'),
            firstGid: 5,
            columns: 1,
            tileCount: 2,
            tiles: [
              Tile(localId: 0),
              Tile(localId: 1),
            ],
          ),
        ],
      );
    });

    test('gets images only in use on each TileLayer', () {
      final tileLayer1 = map.layerByName('tile layer 1');
      final tileLayer2 = map.layerByName('group - tile layer 1');

      final images1 = map.collectImagesInLayer(tileLayer1);
      final images2 = map.collectImagesInLayer(tileLayer2);

      expect(images1, hasLength(1));
      expect(images1[0].source, equals('tileset_1.png'));

      expect(images2, hasLength(2));
      expect(images2[0].source, equals('tileset_1.png'));
      expect(images2[1].source, equals('tileset_2.png'));
    });

    test('gets no image if TileLayer is empty', () {
      final tileLayer = map.layerByName('tile layer 3 (empty)');

      final images = map.collectImagesInLayer(tileLayer);

      expect(images, hasLength(0));
    });

    test('gets all images recursively in the Group', () {
      final tileLayerInsideGroup = map.layerByName('group layer 1');

      final images3 = map.collectImagesInLayer(tileLayerInsideGroup);

      expect(images3, hasLength(3));
      expect(images3[0].source, equals('tileset_1.png'));
      expect(images3[1].source, equals('tileset_2.png'));
      expect(images3[2].source, equals('tileset_3.png'));
    });

    test('gets a image in the ImageLayer', () {
      final imageLayer = map.layerByName('image layer 1');

      final images = map.collectImagesInLayer(imageLayer);

      expect(images, hasLength(1));
      expect(images[0].source, equals('image_layer.png'));
    });

    test('gets no image in the ObjectLayer', () {
      final imageLayer = map.layerByName('object layer 1');

      final images = map.collectImagesInLayer(imageLayer);

      expect(images, hasLength(0));
    });
  });

  group('Map.tiledImages', () {
    late TiledMap map;
    setUp(() {
      map = TiledMap(
        width: 10,
        height: 10,
        tileWidth: 16,
        tileHeight: 16,
        layers: [
          ImageLayer(
            name: 'image layer 1',
            image: const TiledImage(),
            repeatX: false,
            repeatY: false,
          ),
          ImageLayer(
            name: 'image layer 2',
            image: const TiledImage(source: 'image_layer_2.png'),
            repeatX: false,
            repeatY: false,
          ),
        ],
        tilesets: [
          Tileset(
            name: 'tileset 1',
            image: const TiledImage(source: 'tileset_1.png'),
          ),
          Tileset(
            name: 'tileset 2',
            image: const TiledImage(),
          ),
          Tileset(
            name: 'tileset 3',
            tiles: [
              Tile(
                localId: 0,
                image: const TiledImage(source: 'tile_0.png'),
              ),
              Tile(
                localId: 1,
                image: const TiledImage(),
              ),
            ],
          )
        ],
      );
    });
    test('returns images with source', () {
      final imageSources = map.tiledImages().map((e) => e.source);

      expect(imageSources, hasLength(3));
      expect(
        imageSources,
        containsAll(
          <String>[
            'image_layer_2.png',
            'tileset_1.png',
            'tile_0.png',
          ],
        ),
      );
    });
  });

  group('Map.getTileSet', () {
    late TiledMap map;
    final tileset = Tileset(
      name: 'Humans',
      firstGid: 1,
      columns: 32,
      tileCount: 64 * 32,
    );
    setUp(() {
      map = TiledMap(
        width: 100,
        height: 100,
        tileWidth: 16,
        tileHeight: 16,
        tilesets: [tileset],
      );
    });

    test('raises an ArgumentError if tileset is not present', () {
      expect(
        () => map.tilesetByName('Quackers'),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('returns the expected tileset', () {
      expect(map.tilesetByName('Humans'), equals(tileset));
    });
  });
}
