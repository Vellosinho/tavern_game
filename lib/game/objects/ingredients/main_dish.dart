import 'package:bonfire/bonfire.dart';
import 'package:projeto_gbb_demo/game/objects/ingredients/ingredients_sprite_sheet.dart';
import 'package:projeto_gbb_demo/players/controller/player_controller.dart';

class MainDish extends GameDecoration with Attackable {
  PlayerOneController playerOneController;
  MainDish({required super.position, required this.playerOneController})
      : super.withSprite(
            sprite: IngredientsSpriteSheet.rawGriffinBreast, size: Vector2(192, 192))
  // : super.withSprite(sprite: GameObjectsSprites.anvil, position: position, size: Vector2(96, 96))
  ;
  @override
  Future<void> onLoad() async {
    // add(RectangleHitbox(
    //   size: Vector2(192, 96),
    //   position: Vector2(0, 80),
    // ));
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

    // updateMainDishSprite();
    super.onReceiveDamage(attacker, 0.0, identify, damageType);
  }
}
