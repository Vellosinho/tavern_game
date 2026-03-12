import 'package:bonfire/bonfire.dart';
import 'package:projeto_gbb_demo/game/controller/game_controller.dart';
import 'package:projeto_gbb_demo/game/objects/object_sprites.dart';

class Chest extends GameDecoration with Attackable {
  LocalGameController localGameController;
  Chest({required super.position, required this.localGameController})
      : super.withSprite(
            sprite: GameObjectsSprites.chest, size: Vector2(192, 192))
  // : super.withSprite(sprite: GameObjectsSprites.anvil, position: position, size: Vector2(96, 96))
  ;
  @override
  Future<void> onLoad() async {
    add(RectangleHitbox(
      size: Vector2(192, 96),
      position: Vector2(0, 80),
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
    if (localGameController.currentArmor == 'yeti') {
      localGameController.changeEquipment('griffin');
    } else {
      localGameController.changeEquipment('yeti');
    }
    
    // localGameController.minigameIsActive
    //     ? localGameController.miniGameHit()
    //     : localGameController.startMinigame(position, damage);

    // updateChestSprite();
    super.onReceiveDamage(attacker, 0.0, identify, damageType);
  }
}
