import 'dart:async';
import 'dart:math';

import 'package:bonfire/bonfire.dart';
import 'package:flutter/services.dart';
import 'package:projeto_gbb_demo/game/enum/one_time_animations.dart';
import 'package:projeto_gbb_demo/game/controller/game_controller.dart';
import 'package:projeto_gbb_demo/maps/griffin/griffin_sprite_sheet.dart';
import 'package:projeto_gbb_demo/players/player_one/blacksmith/hammer.dart';
import 'package:projeto_gbb_demo/players/player_one/player_one_animations.dart';

import '../../../game/enum/character_faction.dart';
import '../../../game/game_sprite_sheet.dart';
import 'package:bonfire/player/lit_player.dart';

/* 
  static Vector2 characterSize = Vector2(192, 192);
  static Vector2 characterHitbox = Vector2(96, 40);
*/

class Griffin extends SimpleEnemy with BlockMovementCollision {

  LocalGameController localGameController;
  bool isFlying = false;
  bool onCoolDown = false;

  final String id;
  Griffin({
    required super.position,
    required this.localGameController,
    required this.id,
  }) : super(
          life: 200,
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
    add(RectangleHitbox(
        size: Vector2(256, 128),
        position: Vector2(270, 668)));
  }

  void removeColisions() {
    remove(this.shapeHitboxes[0]);
  }

  void takeFlight() {
    onCoolDown = true;
    removeColisions();
    animation?.playOnce(GriffinSprites.griffinTakeOf).then((_) {
    simpleAttackMeleeByDirection(damage: 40, withPush: true, size: Vector2(796, 796), direction: Direction.down, centerOffset: Vector2(0, -260), attackFrom: AttackOriginEnum.ENEMY);
      replaceAnimation(SimpleDirectionAnimation(idleRight: GriffinSprites.flyingGriffin, runRight: GriffinSprites.flyingGriffin));
      isFlying = true;
      Future.delayed(Duration(milliseconds: 100), () {
        animation?.play(SimpleAnimationEnum.idleRight);
      });
    });
    speed = 400;
    Future.delayed(Duration(seconds: 3), () {
      onCoolDown = false;
      getNextMove();
    });
  }

  void landAttack() {
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
    Future.delayed(Duration(seconds: 3), () {
      onCoolDown = false;
      getNextMove();
    });
  }

  void fastAttack() {
    onCoolDown = true;
    stopMove();
    animation?.playOnce(GriffinSprites.griffinLanding).then((_) {
      speed = 0;
      animation?.playOnce(GriffinSprites.griffinFastTakeOf).then((_) => speed = 280);
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
    super.onReceiveDamage(attacker, damage, identify, damageType);
  }

  @override
  void onDie() {
    animation?.playOnce(GriffinSprites.griffinTakeOf);
    super.onDie();
  }

  @override
  void update(double dt) {
    // localGameController.checkMinigameDistance(position);\
    (isFlying && !onCoolDown) ? seeAndMoveToPlayer(
      radiusVision: 10000,
    ) : null;
    super.update(dt);
  }

  void getNextMove() {
    print("Getting next move");
    Random rand = Random();
    int dice = rand.nextInt(4);

    if(dice == 1) {
      print("landing or taking flight");
      if (!isFlying) {
        takeFlight();
      } else {
        speed = 0;
        Random rand = Random();
        int dice = rand.nextInt(2);
        if (dice != 1) {
          fastAttack();
        } else {
          landAttack();
        }
      }
    } else {
      Future.delayed(Duration(seconds: 2), () {
        getNextMove();
      });
    }
  }
}