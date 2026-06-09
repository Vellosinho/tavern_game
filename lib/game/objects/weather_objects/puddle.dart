import 'package:bonfire/bonfire.dart';
import 'package:projeto_gbb_demo/game/controller/game_controller.dart';
import 'package:projeto_gbb_demo/game/enum/weather.dart';
import 'package:projeto_gbb_demo/game/objects/object_sprites.dart';

class Puddle extends GameDecoration {
  int variation;
  LocalGameController controller;
  Puddle({
    required this.controller,
    required this.variation,
    required super.position})
      : super.withAnimation(
          animation: (variation == 0) ? GameObjectsSprites.puddle1
          : (variation == 1) ? GameObjectsSprites.puddle2
          : (variation == 2) ? GameObjectsSprites.puddle3 : GameObjectsSprites.puddle4,
          size: Vector2(192, 192))
  ;
  @override
  Future<void> onLoad() async {
    spawn();
    add(RectangleHitbox(
      size: Vector2(0, 192),
      position: Vector2(0, -1000),
    ));
    // final program = await FragmentProgram.fromAsset('shaders/myshader.frag');
    return super.onLoad();
  }

  checkIsStillRaining() {
    if (controller.currentWeather != Weather.rain) {
      dry();
    }

    Future.delayed(Duration(seconds: 10), () {
      checkIsStillRaining();
    });
  }

  void spawn() {
    playSpriteAnimationOnce(getPuddleSpawnAnimation());
    checkIsStillRaining();
  }

  void dry() {
    playSpriteAnimationOnce(getPuddleDryingAnimation()).then((_) {
      removeFromParent();
    });
  }

  Future<SpriteAnimation> getPuddleDryingAnimation() {
    switch(variation) {
      case 0:
        return GameObjectsSprites.puddleDry1;
      case 1:
        return GameObjectsSprites.puddleDry2;
      case 2:
        return GameObjectsSprites.puddleDry3;
      case 3:
        return GameObjectsSprites.puddleDry4;
      default:
        return GameObjectsSprites.puddleDry1;
    }
  }

  Future<SpriteAnimation> getPuddleSpawnAnimation() {
    switch(variation) {
      case 0:
        return GameObjectsSprites.puddleAppear1;
      case 1:
        return GameObjectsSprites.puddleAppear2;
      case 2:
        return GameObjectsSprites.puddleAppear3;
      case 3:
        return GameObjectsSprites.puddleAppear4;
      default:
        return GameObjectsSprites.puddleAppear1;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
  }
}
