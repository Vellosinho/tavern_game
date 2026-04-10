import 'package:bonfire/bonfire.dart';
import 'package:projeto_gbb_demo/common/common.dart';
import 'package:bonfire/player/lit_player.dart';
import 'package:projeto_gbb_demo/players/consts.dart';
import 'package:projeto_gbb_demo/players/player_one/base_player.dart';

mixin Weapon on LitPlayer {
  double? damage = 5;
  DamageType damageType = DamageType.NONE;
  int holdHits = 0;
  bool attackReady = true;
  bool attackHold = false;
  bool holdAttackUsed = false;
  bool holdReady = true;

  void weaponAttack(JoystickActionEvent event) {
    if ((damage ?? 5) >= 20) {
      // if(event.id.keyId == LogicalKeyboardKey.keyZ.keyId && holdReady && event.event == ActionEvent.DOWN) {
      if (event.id.keyId == LogicalKeyboardKey.keyZ.keyId) {
        if (event.event == ActionEvent.DOWN && holdReady) {
          holdHits = 0;
          attackHold = true;
          Future.delayed(Duration(milliseconds: 300), () {
            if (attackHold) {
              setupElementalLighting(width * 1.2);
              replaceAnimation(spinningBlacksmithAttack);
              holdAttackUsed = true;
              holdReady = false;
              advancedWeaponAttack();
            }
          });
        } else if (event.event == ActionEvent.UP) {
          attackHold = false;
          if (holdAttackUsed) {
            setupElementalLighting(0);
            holdReady = false;
            replaceAnimation(communistArmedBlacksmith);
            holdAttackUsed = false;
          } else {
            if (attackReady) {
              simpleHit();
            }
          }
        }
      }
    } else {
      if (attackReady) {
        simpleHit();
      }
    }
  }

  void advancedWeaponAttack() {
    simpleAttackMelee(
      centerOffset: Vector2(-96, 0),
      withPush: false,
      damage: 10,
      size: Vector2(384, 276),
      // animationRight: GameSpriteSheet.hammerSpinAttack,
      animationRight: GameSpriteSheet.hammerSpinAttackFire,
      // animationRight: GameSpriteSheet.hammerSpinAttackHammer,
      direction: Direction.right,
      damageType: DamageType.FIRE,
    );
    Future.delayed(Duration(milliseconds: 300), () {
      if (attackHold && holdHits < 10) {
        setupElementalLighting(width * 1.2 - holdHits * 16);
        advancedWeaponAttack();
        holdHits++;
      } else {
        holdReady = false;
        setupElementalLighting(0);
        replaceAnimation(communistArmedBlacksmith);
        Future.delayed(Duration(seconds: 10), () {
          holdReady = true;
        });
      }
    });
  }

  void setupElementalLighting(double radius) {
    setupLighting(
      LightingConfig(
        radius: radius,
        color: ElementColors().getElementColor(damageType).withAlpha(80),
        blurBorder: 160,
        align: Vector2(0, 128),
      ),
    );
  }

  void simpleHit() {
    // if(hasGameRef && !gameRef.camera.) {
    if (hasGameRef) {
      simpleAttackMelee(
        sizePush: 0.2,
        damage: 20,
        withPush: ((damage ?? 5) >= 20) ? true : false,
        size: size * 1.15,
        animationRight: ((damage ?? 5) >= 20)
            ? GameSpriteSheet.hammerAttackHorizontalRight
            : GameSpriteSheet.attackHorizontalRight,
        direction: lastDirection,
      );
      // position.translate(diffBase.x, diffBase.y);
      attackReady = false;
      Future.delayed(const Duration(seconds: 1), () {
        attackReady = true;
      });
    }
  }
}
