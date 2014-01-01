part of citadel_server;

void movementSystem() {
  var matching = entitiesWithComponents([Position, Velocity]);

  matching.forEach( (entity) {
    var pos = entity[Position];
    var vel = entity[Velocity];

    if (vel.x != 0 || vel.y != 0) {

      pos.x += vel.x;
      pos.y += vel.y;

      vel.x = 0;
      vel.y = 0;

      commandQueue.add({
          'type': 'move_entity',
          'payload': { 'x': pos.x, 'y': pos.y, 'entity_id': entity.id },
      });
    }
  });

}