import 'package:bonfire/bonfire.dart';
import 'package:projeto_gbb_demo/game/objects/object_sprites.dart';
import 'package:projeto_gbb_demo/players/controller/player_controller.dart';

class Stove extends GameDecoration with Attackable {
  PlayerOneController playerOneController;
  Stove({required super.position, required this.playerOneController})
      : super.withSprite(
            sprite: GameObjectsSprites.stove, size: Vector2(384, 384))
  // : super.withSprite(sprite: GameObjectsSprites.anvil, position: position, size: Vector2(96, 96))
  ;
  @override
  Future<void> onLoad() async {
    add(RectangleHitbox(
      size: Vector2(384, 192),
      position: Vector2(0, 176),
    ));
    // final program = await FragmentProgram.fromAsset('shaders/myshader.frag');
    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
  }

  @override
  void onReceiveDamage(attacker, double damage, identify, damageType) {
    // if (playerOneController.currentArmor == 'yeti') {
    //   playerOneController.changeEquipment('griffin');
    // } else { 
    //   playerOneController.changeEquipment('yeti');
    // }
    
    // localGameController.minigameIsActive
    //     ? localGameController.miniGameHit()
    //     : localGameController.startMinigame(position, damage);

    // updateStoveSprite();
    super.onReceiveDamage(attacker, 0.0, identify, damageType);
  }
}
