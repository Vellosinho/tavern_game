import 'package:bonfire/bonfire.dart';
import 'package:projeto_gbb_demo/game/objects/object_sprites.dart';

class Waterfall extends GameDecoration {
  Waterfall({required super.position})
      : super.withAnimation(
            animation: GameObjectsSprites.waterfall, size: Vector2(768, 960))
  // : super.withSprite(sprite: GameObjectsSprites.anvil, position: position, size: Vector2(96, 96))
  ;
  @override
  Future<void> onLoad() async {
    add(RectangleHitbox(
      size: Vector2(768, 160),
      position: Vector2(0, 800),
    ));
    // final program = await FragmentProgram.fromAsset('shaders/myshader.frag');
    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
  }
}
