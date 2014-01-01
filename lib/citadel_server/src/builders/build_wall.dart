part of citadel_server;

Entity buildWall(x, y) {
  var entity = new Entity();

  entity.attach(new Position(x, y));
  entity.attach(new Collidable());

  liveEntities.add(entity);
  return entity;
}