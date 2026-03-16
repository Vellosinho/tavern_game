import 'package:bonfire/bonfire.dart';
import 'package:projeto_gbb_demo/game/controller/game_controller.dart';
import 'package:projeto_gbb_demo/game/objects/object_sprites.dart';
import 'package:projeto_gbb_demo/maps/griffin/griffin_sprite_sheet.dart';

class Pillar extends GameDecoration with Attackable {
  int pillarNumber;
  Pillar({required super.position, required this.pillarNumber})
      : super.withSprite(
            sprite: (pillarNumber == 1) ? GriffinSprites.pillar1
              : (pillarNumber == 2) ? GriffinSprites.pillar2
              : ((pillarNumber == 3) || (pillarNumber == 4)) ? GriffinSprites.pillar3
              : (pillarNumber == 5) ? GriffinSprites.pillar5
              : (pillarNumber == 6) ? GriffinSprites.pillar6
              : GriffinSprites.pillar7,
            size: ((pillarNumber == 1) || (pillarNumber == 2)) 
              ? Vector2(384, 768) 
              : ((pillarNumber == 3) || (pillarNumber == 4))  
                ? Vector2(384, 964) 
                : (pillarNumber == 5) ? Vector2(384, 964) : (pillarNumber == 6) 
                  ? Vector2(384, 1160) 
                  : Vector2(384, 1356));

  @override
  Future<void> onLoad() {
    add(RectangleHitbox(
      size: Vector2(384, 280),
      position: Vector2(0, size.y - 300),
    ));
    return super.onLoad();
  }
}
