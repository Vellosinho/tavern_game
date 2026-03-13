import 'package:flutter/material.dart';
import 'package:bonfire/bonfire.dart';


class GriffinSprites {
  // Communist Sprites

  // Blacksmith

  // One Time animations
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
  
}