import 'package:bonfire/bonfire.dart';
import 'package:projeto_gbb_demo/game/objects/object_sprites.dart';
import 'package:projeto_gbb_demo/players/controller/player_controller.dart';

// class Bed {
//   Vector2 position;
//   PlayerOneController playerOneController;
//   List<GameComponent> bed => [
//     BedBackground(position: position, playerOneController: playerOneController),
//     BedForeground(position: position, playerOneController: playerOneController),
//   ];

//   Bed({required this.position, required this.playerOneController});
// }


class BedBackground extends GameDecoration with Attackable {
  PlayerOneController playerOneController;
  BedBackground({required super.position, required this.playerOneController})
      : super.withSprite(
            sprite: GameObjectsSprites.bedBackground, size: Vector2(384, 384))
  // : super.withSprite(sprite: GameObjectsSprites.anvil, position: position, size: Vector2(96, 96))
  ;
  @override
  Future<void> onLoad() async {
    add(RectangleHitbox(
      size: Vector2(384, 40),
      position: Vector2(0, 0),
    ));
    // final program = await FragmentProgram.fromAsset('shaders/myshader.frag');
    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
  }
}


class BedForeground extends GameDecoration with Attackable {
  PlayerOneController playerOneController;
  BedForeground({required super.position, required this.playerOneController})
      : super.withSprite(
            sprite: GameObjectsSprites.bedForeground, size: Vector2(384, 384))
  // : super.withSprite(sprite: GameObjectsSprites.anvil, position: position, size: Vector2(96, 96))
  ;
  @override
  Future<void> onLoad() async {
    add(RectangleHitbox(
      size: Vector2(384, 40),
      position: Vector2(0, 344),
    ));
    // final program = await FragmentProgram.fromAsset('shaders/myshader.frag');
    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
  }
}
