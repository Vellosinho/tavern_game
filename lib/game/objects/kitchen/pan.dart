import 'package:bonfire/bonfire.dart';
import 'package:projeto_gbb_demo/game/objects/object_sprites.dart';
import 'package:projeto_gbb_demo/players/controller/player_controller.dart';

class Pan extends GameDecoration with Attackable {
  PlayerOneController playerOneController;
  Pan({required super.position, required this.playerOneController})
      : super.withSprite(
            sprite: GameObjectsSprites.pan, size: Vector2(192, 192))
  // : super.withSprite(sprite: GameObjectsSprites.anvil, position: position, size: Vector2(96, 96))
  ;
  @override
  Future<void> onLoad() async {
    add(RectangleHitbox(
      size: Vector2(96, 196),
      position: Vector2(32, 128),
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
