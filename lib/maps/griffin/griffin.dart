import 'dart:async';
import 'dart:math';

import 'package:bonfire/bonfire.dart';
import 'package:projeto_gbb_demo/game.dart';
import 'package:projeto_gbb_demo/game/controller/game_controller.dart';
import 'package:projeto_gbb_demo/maps/griffin/griffin_sprite_sheet.dart';
import 'package:projeto_gbb_demo/maps/griffin/objects/tornado.dart';

/* 
  static Vector2 characterSize = Vector2(192, 192);
  static Vector2 characterHitbox = Vector2(96, 40);
*/

class Griffin extends SimpleEnemy with BlockMovementCollision {

  LocalGameController localGameController;
  bool isFlying = false;
  bool followingPlayer = false;
  bool onCoolDown = false;
  bool isMidAnimation = false;
  bool get isHome => ((position.x - (tileSize * 16)).abs() < 400) && ((position.y - (tileSize * 4)).abs() < 400);

  final String id;
  Griffin({
    required super.position,
    required this.localGameController,
    required this.id,
  }) : super(
          life: 1000,
          initDirection: Direction.down,
          size: Vector2(796, 796),
          animation: SimpleDirectionAnimation(idleRight: GriffinSprites.griffinBase, runRight: GriffinSprites.griffinBase),
          // speed: PlayerConsts.characterSpeed,
          speed: 350,
          keepRendered: true,
        );
        
  @override
  Future<void> onLoad() {
    setupColisions();
    Future.delayed(Duration(milliseconds: 2500), () {
      getNextMove();
    });
    return super.onLoad();
  }
  
  void setupColisions() {
    if (shapeHitboxes.isEmpty) {
      add(RectangleHitbox(
          size: Vector2(256, 128),
          position: Vector2(270, 668)));
    }
  }

  void removeColisions() {
    if (shapeHitboxes.isNotEmpty) {
      remove(this.shapeHitboxes[0]);
    }
  }

  void takeFlight({required Function onAir}) {
    onCoolDown = true;
    isMidAnimation = true;
    removeColisions();
    animation?.playOnce(GriffinSprites.griffinTakeOf).then((_) {
    simpleAttackMeleeByDirection(damage: 40, withPush: true, size: Vector2(796, 796), direction: Direction.down, centerOffset: Vector2(0, -260), attackFrom: AttackOriginEnum.ENEMY);
      replaceAnimation(SimpleDirectionAnimation(idleRight: GriffinSprites.flyingGriffin, runRight: GriffinSprites.flyingGriffin));
      isFlying = true;
      Future.delayed(Duration(milliseconds: 100), () {
        animation?.play(SimpleAnimationEnum.idleRight);
      });
    });
    speed = 600;
    Future.delayed(Duration(seconds: 2), () {
      onCoolDown = false;
      onAir();
    });
  }

  void landAttack() {
    land(onLand: () {
      getNextMove();
    });
  }

  void land({required Function onLand}) {
    stopMove();
    speed = 0;
    onCoolDown = true;
    animation?.playOnce(GriffinSprites.griffinLanding).then((_) {
      replaceAnimation(SimpleDirectionAnimation(idleRight: GriffinSprites.griffinBase, runRight: GriffinSprites.griffinBase),);
      simpleAttackMeleeByDirection(damage: 40, withPush: true, size: Vector2(796, 796), direction: Direction.down, centerOffset: Vector2(0, -260), attackFrom: AttackOriginEnum.ENEMY);
      Future.delayed(Duration(milliseconds: 100), () {
        animation?.play(SimpleAnimationEnum.idleRight);
      });
      setupColisions();
      isFlying = false;
    });
    Future.delayed(Duration(seconds: 1), () {
      onCoolDown = false;
      isMidAnimation = false;
      onLand();
    });
  }

  void fastAttack() {
    onCoolDown = true;
    stopMove();
    animation?.playOnce(GriffinSprites.griffinLanding).then((_) {
      speed = 0;
      animation?.playOnce(GriffinSprites.griffinFastTakeOf).then((_) => speed = 600);
    });
    simpleAttackMeleeByDirection(damage: 40, withPush: true, size: Vector2(796, 796), direction: Direction.down, centerOffset: Vector2(0, -260), attackFrom: AttackOriginEnum.ENEMY);
    Future.delayed(Duration(seconds: 4), () {
      onCoolDown = false;
      getNextMove();
    });
  }

  @override
  void onReceiveDamage(attacker, double damage, identify, damageType) {
    // onHit();
    print("life: $life");
    !isMidAnimation ? animation?.playOnce(GriffinSprites.griffinHurt) : null;
    if (isFlying) {
      damage = 0;
    }
    super.onReceiveDamage(attacker, damage, identify, damageType);
  }

  @override
  void onDie() {
    animation?.playOnce(GriffinSprites.griffinDie).then((_) {
      gameRef.add(DeadGriffin(position: position));
      removeFromParent();
    });
    super.onDie();
  }

  int _updateCount = 0;
  void updateCount() {
    if (_updateCount == 30) {
      _updateCount = 0;
      (isFlying && !onCoolDown) ? seeAndMoveToPlayer(
        radiusVision: 10000,
      ) : null;
    } else {
      _updateCount++;
    }
  }

  @override
  void update(double dt) {
    // localGameController.checkMinigameDistance(position);\
    followingPlayer ? updateCount() : null;
    
    super.update(dt);
  }

  void goHome({required Function onArrival}) {
    moveToPosition(Vector2(tileSize * 16, tileSize * 9), useCenter: true);
    if (isHome) {
      stopMove();
      print("isHome");
      onArrival();
    } else {
      Future.delayed(Duration(milliseconds: 2), () {
        goHome(onArrival: () => onArrival());
      });
    }
  }

  void windAttackExecute() {
    isMidAnimation = true;
    Future.delayed(Duration(milliseconds: 100), () {
    animation?.playOnce(GriffinSprites.griffinWindAttackLanding).then((_) {
          setupColisions();
          replaceAnimation(SimpleDirectionAnimation(idleRight: GriffinSprites.windAttackTakeOf, runRight: GriffinSprites.windAttackTakeOf));
          removeColisions();
          Future.delayed(Duration(milliseconds: 100), () {
            setupColisions();
            animation?.play(SimpleAnimationEnum.idleRight);
            speed = 2000;
            loopAttack();
            moveDown();
            Future.delayed(Duration(seconds: 2), () {
              stopMove();
              speed = 800;
              animation?.playOnce(GriffinSprites.griffinWindAttackTakeOf).then((_) {
                isFlying = true;
                removeColisions();
                replaceAnimation(SimpleDirectionAnimation(idleRight: GriffinSprites.flyingGriffin, runRight: GriffinSprites.flyingGriffin));
                goHome(onArrival: () {
                  landAttack();
                  isMidAnimation = false;
                });
              });
            });
          });
        });
      });
  }
  
  void loopAttack() {
    simpleAttackMeleeByDirection(damage: 5, withPush: true, size: Vector2(796, 796), direction: Direction.down, centerOffset: Vector2(0, -260), attackFrom: AttackOriginEnum.ENEMY);
    if (!isFlying) {
      Future.delayed(Duration(milliseconds: 100), () {
        loopAttack();
      });
    }
  }

  void stunAttack() {
    simpleAttackMeleeByDirection(damage: 0, withPush: false, size: Vector2(1592, 1592), direction: Direction.down, centerOffset: Vector2(0, -260), attackFrom: AttackOriginEnum.ENEMY, damageType: DamageType.STUN);
  }

  void windAttack() {
    isMidAnimation = true;
    Future.delayed(Duration(milliseconds: 600), () {
      stunAttack();
    });
    animation?.playOnce(GriffinSprites.griffinScreechFlight).then((_) {
      removeColisions();
      replaceAnimation(SimpleDirectionAnimation(idleRight: GriffinSprites.flyingGriffin, runRight: GriffinSprites.flyingGriffin));
      Future.delayed(Duration(milliseconds: 100), () {
        animation?.play(SimpleAnimationEnum.idleRight);
      });
      speed = 800;
      if(isHome) {
        windAttackExecute();
      } else {
        goHome(onArrival: () {
          windAttackExecute();
        });
      }
      animation?.playOnce(GriffinSprites.griffinWindAttackLanding).then((_) {
        isMidAnimation = false;
      });
    });
  }

  void getNextMove() {
    Random rand = Random();
    int dice = rand.nextInt(7);
    print("dice: $dice");

    if(dice == 1) {
      if (!isFlying) {
        takeFlight(
          onAir: () {
            followingPlayer = true;
            getNextMove();
          });
      } else {
        speed = 0;
        Random rand = Random();
        int dice = rand.nextInt(2);
        if (dice != 1) {
          fastAttack();
        } else {
          followingPlayer = false;
          landAttack();
        }
      }
    } else if ((dice == 2) && (!isFlying)) {
        windAttack();
    } else if ((dice == 3) && (!isFlying)) {
        tornadoAttack();
    } else if ((dice == 4) && (isFlying)) {
        landAttack();
    } else {
      Future.delayed(Duration(seconds: 2), () {
        getNextMove();
      });
    }
  }

  void tornadoAttack() {
    isMidAnimation = true;
    animation?.playOnce(GriffinSprites.launchTornado).then((_) {
      replaceAnimation(SimpleDirectionAnimation(idleRight: GriffinSprites.flyingGriffin, runRight: GriffinSprites.flyingGriffin));
      isFlying = true;
      removeColisions();
      Future.delayed(Duration(milliseconds: 100), () {
        animation?.play(SimpleAnimationEnum.idleRight);
      });
      summonTornado();
      
      Future.delayed(Duration(seconds: 3), () {
        getNextMove();
      });
    });
  }

  void summonTornado() {
    gameRef.add(Tornado(position: position));
  }
}
class DeadGriffin extends GameDecoration with Attackable {
  DeadGriffin({required super.position})
      : super.withSprite(
            sprite: GriffinSprites.deadGriffin,
            size: Vector2(796, 796),
          );

  @override
  Future<void> onLoad() {
    add(RectangleHitbox(
          size: Vector2(256, 128),
          position: Vector2(270, 668)));
    return super.onLoad();
  }
}
