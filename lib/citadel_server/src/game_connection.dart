part of citadel_server;

class GameConnection {
  WebSocket ws;
  // TODO: this represents the player owned by the websocket connection.
  Entity entity;

  GameConnection(this.ws, this.entity);
}