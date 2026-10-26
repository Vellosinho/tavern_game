import 'package:bonfire/bonfire.dart';
import 'package:projeto_gbb_demo/game/objects/object_sprites.dart';

class Anvil extends GameDecoration {
  Anvil({required super.position})
      : super.withSprite(sprite: GameObjectsSprites.anvil, size: Vector2(192, 192))
  // : super.withSprite(sprite: GameObjectsSprites.anvil, position: position, size: Vector2(96, 96))
  ;
  @override
  Future<void> onLoad() async {
    add(RectangleHitbox(
      size: Vector2(90, 90),
      position: Vector2(51, 102),
    ));
    // final program = await FragmentProgram.fromAsset('shaders/myshader.frag');
    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
  }
}
