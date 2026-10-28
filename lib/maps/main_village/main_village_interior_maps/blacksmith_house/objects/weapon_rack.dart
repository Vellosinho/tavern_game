import 'package:bonfire/bonfire.dart';
import 'package:projeto_gbb_demo/game/objects/object_sprites.dart';

class WeaponRack extends GameDecoration {
  WeaponRack({required super.position})
      : super.withSprite(sprite: GameObjectsSprites.weaponRack, size: Vector2(384, 192))
  // : super.withSprite(sprite: GameObjectsSprites.WeaponRack, position: position, size: Vector2(96, 96))
  ;
  @override
  Future<void> onLoad() async {
    add(RectangleHitbox(
      size: Vector2(384, 90),
      position: Vector2(0, 130),
    ));
    // final program = await FragmentProgram.fromAsset('shaders/myshader.frag');
    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
  }
}
