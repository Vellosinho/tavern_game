import 'package:bonfire/bonfire.dart';
import 'package:projeto_gbb_demo/maps/griffin/griffin_sprite_sheet.dart';

class Tornado extends SimpleEnemy with BlockMovementCollision {

  Tornado({
    required super.position,
  }) : super(
          life: 200,
          initDirection: Direction.down,
          size: Vector2(796, 796),
          animation: SimpleDirectionAnimation(idleRight: GriffinSprites.tornado, runRight: GriffinSprites.tornado),
          // speed: PlayerConsts.characterSpeed,
          speed: 350,
          keepRendered: true,
        );


  void setupColisions() {
    if (shapeHitboxes.isEmpty) {
      add(RectangleHitbox(
          size: Vector2(256, 128),
          position: Vector2(270, 668)));
    }
  }

  @override
  Future<void> onLoad() {
    followPlayer();
    loopAttack();
    setupColisions();
    Future.delayed(Duration(seconds: 8), () {
      // getNextMove();
      animation?.playOnce(GriffinSprites.tornadoFading).then((_) => removeFromParent());
    });
    return super.onLoad();
  }

  void followPlayer() {
    seeAndMoveToPlayer(
        radiusVision: 10000,
      );
    Future.delayed(Duration(milliseconds: 200), () {
      followPlayer();
    });
  }

  void loopAttack() {
    simpleAttackMeleeByDirection(damage: 5, withPush: true, size: Vector2(320, 320), direction: Direction.down, centerOffset: Vector2(0, -260), attackFrom: AttackOriginEnum.ENEMY);

    Future.delayed(Duration(milliseconds: 100), () {
      loopAttack();
    });
  }

}