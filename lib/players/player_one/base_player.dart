import 'dart:async';

import 'package:bonfire/bonfire.dart';
import 'package:flutter/services.dart';
import 'package:projeto_gbb_demo/game/enum/one_time_animations.dart';
import 'package:projeto_gbb_demo/game/game_sprite_sheet.dart';
import 'package:projeto_gbb_demo/players/controller/player_controller.dart';
import 'package:projeto_gbb_demo/players/player_consts.dart';
import 'package:projeto_gbb_demo/players/player_one/weapons/weapon.dart';
import 'package:projeto_gbb_demo/players/player_one/player_one_animations.dart';

import 'package:bonfire/player/lit_player.dart';

/* 
  static Vector2 characterSize = Vector2(192, 192);
  static Vector2 characterHitbox = Vector2(96, 40);
*/

class BasePlayer extends LitPlayer with BlockMovementCollision, Weapon {
  Function onHit;
  double playerLife;
  PlayerOneAnimations playerOneAnimations = PlayerOneAnimations();
  bool isStunned = false;

  // control booleans:
  bool dashReady = true;

  bool escPressed = false;
  bool isArmed = false;
  PlayerOneController playerController;

  bool _isPlayingOneTimeAnimation = false;

  final String id;
  BasePlayer({
    required super.position,
    initDirection,
    required this.onHit,
    required this.playerLife,
    required this.playerController,
    required this.id,
  }) : super(
          life: playerLife,
          initDirection: initDirection ?? Direction.down,
          size: PlayerConsts.characterSize,
          animation: playerController.currentPlayerEquipment ?? communistUnarmedBlacksmith,
          // speed: PlayerConsts.characterSpeed,
          speed: PlayerConsts.characterSpeed,
        );
  @override
  Future<void> onLoad() {
    setupColisions();
    return super.onLoad();
  }

  @override
  void onReceiveDamage(attacker, double damage, identify, damageType) {
    print("damage received");
    if (damageType == DamageType.STUN) {
      stun();
    }
    // onHit();
    playerController.hit(damage);
    super.onReceiveDamage(attacker, damage, identify, damageType);
  }

  void stun() {
    stopMove();
    isStunned = true;
    speed = 0;
    Future.delayed(Duration(seconds: 3), () {
      isStunned = false;
      speed = PlayerConsts.characterSpeed;
    });
  }

  @override
  void onJoystickAction(JoystickActionEvent event) {
    !isStunned ? swordsmanHitSet(event) : null;
    return super.onJoystickAction(event);
  }

  @override
  void update(double dt) {
    // playerController.checkMinigameDistance(position);
    playerController.checkImportantCoordsDistance(position);
    playOneTimeAnimations();
    checkChangeGear();
    _isPlayingOneTimeAnimation =
        playerController.playAnimation != OneTimeAnimations.none;
    super.update(dt);
  }

  void swordsmanHitSet(JoystickActionEvent event) {
    if (event.id.keyId == LogicalKeyboardKey.keyZ.keyId) {
      weaponAttack(event);
    }
    if (event.id.keyId == LogicalKeyboardKey.keyX.keyId &&
        dashReady &&
        !_isPlayingOneTimeAnimation) {
      swordsmanDash();
    }
    if (event.id == LogicalKeyboardKey.escape.keyId && !escPressed) {
      // playerController.togglePaused();
      escPressed = true;
      if (playerController.gameIsPaused) {
        gameRef.pauseEngine();
      } else {
        gameRef.resumeEngine();
      }
      Future.delayed(const Duration(milliseconds: 250), () {
        escPressed = false;
      });
    }
  }
  

  void swordsmanDash() {
    speed = 1000;
    animation?.playOnce(playerOneAnimations.getGeneratedDash(playerController, lastDirection.toRadians().toString()) as FutureOr<SpriteAnimation>).then((_) {
      speed = PlayerConsts.characterSpeed;
    });

    dashReady = false;
    Future.delayed(const Duration(seconds: 1), () {
      dashReady = true;
    });
  }

  void checkChangeGear() {
    if ((playerController.currentPlayerEquipment != null) && playerController.updateEquipment) {
        replaceAnimation(playerController.currentPlayerEquipment!).then((_) =>
        Future.delayed(Duration.zero, () {
          animation?.play(SimpleAnimationEnum.idleDown);
        }),
      );
    }
    playerController.equipmentUpdated(); 
  }

  void playOneTimeAnimations() {
    if (playerController.resetColision) {
      setupColisions();
      playerController.toggleResetCollision();
    }
    if (playerController.playAnimation != OneTimeAnimations.none) {
      Future.delayed(Duration(milliseconds: 0), () {
        switch (playerController.playAnimation) {
          case OneTimeAnimations.swordComplete:
            animation?.playOnce(GameSpriteSheet.forgeSuccessful);
            turnOffAnimation();
            return;
          case OneTimeAnimations.perfectSwordComplete:
            animation?.playOnce(GameSpriteSheet.forgeLegedarySuccessful);
            turnOffAnimation();
            return;
          case OneTimeAnimations.acquiredIron:
            animation?.playOnce(GameSpriteSheet.acquiredIron);
            turnOffAnimation();
            return;
          case OneTimeAnimations.shrug:
            animation?.playOnce(isArmed
                ? GameSpriteSheet.communistArmedBlacksmithShrug
                : GameSpriteSheet.communistUnarmedBlacksmithShrug);
            turnOffAnimation();
            return;
          case OneTimeAnimations.acquiredHammer:
            // equipWeapon();
            turnOffAnimation();
            Future.delayed(Duration(milliseconds: 250), () {
              animation?.playOnce(GameSpriteSheet.equippingHammer);
              speed = PlayerConsts.slowCharacterSpeed;
              animation?.play(SimpleAnimationEnum.idleDown);
            });
            return;
          default:
            return;
        }
      });
    }
  }

  void turnOffAnimation() {
    playerController.turnOffAnimation();
  }


  @override
  void setupColisions() {
    add(RectangleHitbox(
        size: PlayerConsts.characterHitbox,
        position: PlayerConsts.characterHitboxPosition));
    super.setupColisions();
  }
}
