part of citadel_server;

// The collision system checks whether a collision will happen next tick.
// If a collision is about to occur, we...
// set velocity to 0.
// TODO: super naive system.
void collisionSystem() {
  var filtered = entitiesWithComponents([Position, Collidable, Velocity]);
  // TODO: velocity is currently -1 per tick.
  // TODO: need to account for different velocity.
  filtered.forEach( (entity) {
    var pos = entity[Position];
    var vel = entity[Velocity];

    var x = pos.x + vel.x;
    var y = pos.y + vel.y;

    // Do any other solid components (moving or not) collide with this one?
    // If so, cease their velocity immediately.
    var collidables = entitiesWithComponents([Position, Collidable])
      .where( (otherEntity) => otherEntity != entity);

    if (collidables.any( (otherEntity) {
      var pos = otherEntity[Position];
      return pos.x == x && pos.y == y;

    })) {
      vel.x = 0;
      vel.y = 0;
    }

  });


}