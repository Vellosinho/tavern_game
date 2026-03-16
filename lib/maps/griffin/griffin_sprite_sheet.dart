import 'package:bonfire/bonfire.dart';


class GriffinSprites {
  static Future<SpriteAnimation> get griffinBase => SpriteAnimation.load(
    'boss/griffin/griffin_base.png',
    SpriteAnimationData.sequenced(amount: 6, stepTime: 0.25, textureSize: Vector2(128, 128))
  );
  static Future<SpriteAnimation> get griffinTakeOf => SpriteAnimation.load(
    'boss/griffin/griffin_takeof.png',
    SpriteAnimationData.sequenced(amount: 13, stepTime: 0.125, textureSize: Vector2(128, 128))
  );
  static Future<SpriteAnimation> get griffinFastTakeOf => SpriteAnimation.load(
    'boss/griffin/griffin_fast_takeof.png',
    SpriteAnimationData.sequenced(amount: 8, stepTime: 0.125, textureSize: Vector2(128, 128))
  );
  static Future<SpriteAnimation> get griffinLanding => SpriteAnimation.load(
    'boss/griffin/griffin_landing.png',
    SpriteAnimationData.sequenced(amount: 7, stepTime: 0.125, textureSize: Vector2(128, 128))
  );
  static Future<SpriteAnimation> get flyingGriffin => SpriteAnimation.load(
    'boss/griffin/flying_griffin.png',
    SpriteAnimationData.sequenced(amount: 1, stepTime: 0.125, textureSize: Vector2(128, 128))
  );
  static Future<SpriteAnimation> get griffinScreechFlight => SpriteAnimation.load(
    'boss/griffin/griffin_screech_flight.png',
    SpriteAnimationData.sequenced(amount: 17, stepTime: 0.125, textureSize: Vector2(128, 128))
  );
  static Future<SpriteAnimation> get griffinWindAttackLanding => SpriteAnimation.load(
    'boss/griffin/wind_attack_landing.png',
    SpriteAnimationData.sequenced(amount: 9, stepTime: 0.125, textureSize: Vector2(128, 128))
  );
  static Future<SpriteAnimation> get griffinWindAttackTakeOf => SpriteAnimation.load(
    'boss/griffin/wind_attack_takeof.png',
    SpriteAnimationData.sequenced(amount: 13, stepTime: 0.125, textureSize: Vector2(128, 128))
  );
  static Future<SpriteAnimation> get windAttackTakeOf => SpriteAnimation.load(
    'boss/griffin/wind_attack.png',
    SpriteAnimationData.sequenced(amount: 4, stepTime: 0.125, textureSize: Vector2(128, 128))
  );
  static Future<SpriteAnimation> get launchTornado => SpriteAnimation.load(
    'boss/griffin/griffin_launch_tornado.png',
    SpriteAnimationData.sequenced(amount: 13, stepTime: 0.125, textureSize: Vector2(128, 128))
  );
  static Future<SpriteAnimation> get tornado => SpriteAnimation.load(
    'boss/griffin/tornado.png',
    SpriteAnimationData.sequenced(amount: 4, stepTime: 0.125, textureSize: Vector2(128, 128))
  );
  static Future<SpriteAnimation> get tornadoFading => SpriteAnimation.load(
    'boss/griffin/tornado_fading.png',
    SpriteAnimationData.sequenced(amount: 6, stepTime: 0.125, textureSize: Vector2(128, 128))
  );
  static Future<SpriteAnimation> get griffinHurt => SpriteAnimation.load(
    'boss/griffin/griffin_hurt.png',
    SpriteAnimationData.sequenced(amount: 4, stepTime: 0.125, textureSize: Vector2(128, 128))
  );
  static Future<SpriteAnimation> get griffinDie => SpriteAnimation.load(
    'boss/griffin/griffin_die.png',
    SpriteAnimationData.sequenced(amount: 18, stepTime: 0.125, textureSize: Vector2(128, 128))
  );


  
  static Future<Sprite> pillar1 = Sprite.load('map/griffin_base/pillar_1.png');
  static Future<Sprite> pillar2 = Sprite.load('map/griffin_base/pillar_2.png');
  static Future<Sprite> pillar3 = Sprite.load('map/griffin_base/pillar_3-4.png');
  static Future<Sprite> pillar5 = Sprite.load('map/griffin_base/pillar_5.png');
  static Future<Sprite> pillar6 = Sprite.load('map/griffin_base/pillar_6.png');
  static Future<Sprite> pillar7 = Sprite.load('map/griffin_base/pillar_7.png');
  static Future<Sprite> deadGriffin = Sprite.load('boss/griffin/dead_griffin.png');
  
}