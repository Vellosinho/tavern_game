import 'package:bonfire/bonfire.dart';

class GameObjectsSprites {
  //anvil sprites:
  static Future<Sprite> anvil = Sprite.load('objects/anvil.png');
  static Future<Sprite> chest = Sprite.load('objects/chest/chest.png');
  static Future<Sprite> bedBackground = Sprite.load('objects/chest/bed_background.png');
  static Future<Sprite> bedForeground = Sprite.load('objects/chest/bed_foreground.png');
  static Future<Sprite> yellowMat = Sprite.load('objects/yellow_mat.png');
  static Future<Sprite> empty = Sprite.load('empty.png');
  static Future<Sprite> anvilFirstHit = Sprite.load('objects/anvil_minigame/anvil_minigame_1.png');
  static Future<Sprite> anvilSecondHit = Sprite.load('objects/anvil_minigame/anvil_minigame_2.png');
  static Future<Sprite> anvilThirdHit = Sprite.load('objects/anvil_minigame/anvil_minigame_3.png');
  static Future<Sprite> anvilFourthHit = Sprite.load('objects/anvil_minigame/anvil_minigame_4.png');
  static Future<Sprite> anvilFifthHit = Sprite.load('objects/anvil_minigame/anvil_minigame_5.png');

  //kitchen sprites:
  static Future<Sprite> stove = Sprite.load('objects/kitchen/stove.png');
  static Future<Sprite> pan = Sprite.load('objects/kitchen/pan.png');
  static Future<Sprite> mixingBowl = Sprite.load('objects/kitchen/mixing_bowl.png');
  static Future<Sprite> cuttingBoard = Sprite.load('objects/kitchen/cutting_board.png');

  //Weather sprites:
  static Future<SpriteAnimation> puddle1 = SpriteAnimation.load('effects/puddle_1.png', SpriteAnimationData.sequenced(amount: 9, stepTime: 0.125, textureSize: Vector2(32, 32)));
  static Future<SpriteAnimation> puddle2 = SpriteAnimation.load('effects/puddle_2.png', SpriteAnimationData.sequenced(amount: 9, stepTime: 0.125, textureSize: Vector2(32, 32)));
  static Future<SpriteAnimation> puddle3 = SpriteAnimation.load('effects/puddle_3.png', SpriteAnimationData.sequenced(amount: 9, stepTime: 0.125, textureSize: Vector2(32, 32)));
  static Future<SpriteAnimation> puddle4 = SpriteAnimation.load('effects/puddle_4.png', SpriteAnimationData.sequenced(amount: 9, stepTime: 0.125, textureSize: Vector2(32, 32)));
  static Future<SpriteAnimation> puddleAppear1 = SpriteAnimation.load('effects/puddle_1_appear.png', SpriteAnimationData.sequenced(amount: 6, stepTime: 0.5, textureSize: Vector2(32, 32)));
  static Future<SpriteAnimation> puddleAppear2 = SpriteAnimation.load('effects/puddle_2_appear.png', SpriteAnimationData.sequenced(amount: 6, stepTime: 0.5, textureSize: Vector2(32, 32)));
  static Future<SpriteAnimation> puddleAppear3 = SpriteAnimation.load('effects/puddle_3_appear.png', SpriteAnimationData.sequenced(amount: 6, stepTime: 0.5, textureSize: Vector2(32, 32)));
  static Future<SpriteAnimation> puddleAppear4 = SpriteAnimation.load('effects/puddle_4_appear.png', SpriteAnimationData.sequenced(amount: 6, stepTime: 0.5, textureSize: Vector2(32, 32)));
  static Future<SpriteAnimation> puddleDry1 = SpriteAnimation.load('effects/puddle_1_fade.png', SpriteAnimationData.sequenced(amount: 6, stepTime: 0.5, textureSize: Vector2(32, 32)));
  static Future<SpriteAnimation> puddleDry2 = SpriteAnimation.load('effects/puddle_2_fade.png', SpriteAnimationData.sequenced(amount: 6, stepTime: 0.5, textureSize: Vector2(32, 32)));
  static Future<SpriteAnimation> puddleDry3 = SpriteAnimation.load('effects/puddle_3_fade.png', SpriteAnimationData.sequenced(amount: 6, stepTime: 0.5, textureSize: Vector2(32, 32)));
  static Future<SpriteAnimation> puddleDry4 = SpriteAnimation.load('effects/puddle_4_fade.png', SpriteAnimationData.sequenced(amount: 6, stepTime: 0.5, textureSize: Vector2(32, 32)));
  
  //sword shipping box sprites:
  static Future<Sprite> swordShippingBoxEmpty = Sprite.load('objects/sword_box/sword_box_0.png');
  static Future<Sprite> swordShippingBoxOne = Sprite.load('objects/sword_box/sword_box_1.png');
  static Future<Sprite> swordShippingBoxTwo = Sprite.load('objects/sword_box/sword_box_2.png');
  static Future<Sprite> swordShippingBoxThree = Sprite.load('objects/sword_box/sword_box_3.png');
  static Future<Sprite> swordShippingBoxFour = Sprite.load('objects/sword_box/sword_box_4.png');

  static Future<Sprite> anvilMinigame = Sprite.load('objects/anvil_minigame.png');

  // Smithing Table
  static Future<Sprite> smithingTableEmpty = Sprite.load('objects/smithing_table/empty_smithing_table.png');
  static Future<Sprite> smithingTableHammer = Sprite.load('objects/smithing_table/hammer_smithing_table.png');
  
  //furnace
  static Future<Sprite> furnace = Sprite.load('objects/furnace.png');
  static Future<SpriteAnimation> get activeFurnace => SpriteAnimation.load(
    'objects/active_furnace.png',
    SpriteAnimationData.sequenced(amount: 6, stepTime: 0.2, textureSize: Vector2(64,192))
  );

  // Wheat
  static Future<SpriteAnimation> wheat = SpriteAnimation.load('objects/wheat_fields/wheat_animation.png', SpriteAnimationData.sequenced(amount: 4, stepTime: 0.4, textureSize: Vector2(32, 32)));
  static Future<SpriteAnimation> wheatFire = SpriteAnimation.load('objects/wheat_fields/wheat_fire_animation.png', SpriteAnimationData.sequenced(amount: 4, stepTime: 0.4, textureSize: Vector2(32, 32)));
  static Future<SpriteAnimation> wheatFire2 = SpriteAnimation.load('objects/wheat_fields/wheat_fire_animation_var2.png', SpriteAnimationData.sequenced(amount: 4, stepTime: 0.4, textureSize: Vector2(32, 32)));
  static Future<SpriteAnimation> deadWheat = SpriteAnimation.load('objects/wheat_fields/dead_wheat.png', SpriteAnimationData.sequenced(amount: 1, stepTime: 0.4, textureSize: Vector2(32, 32)));

  //
  static Future<Sprite> launchStation = Sprite.load('objects/launch_station/launch_station_idle.png');
  static Future<SpriteAnimation> launchStationActivation = SpriteAnimation.load('objects/launch_station/launch_station_activating.png', SpriteAnimationData.sequenced(amount: 10, stepTime: 0.2, textureSize: Vector2(92, 70)));
  static Future<Sprite> launchStationActivated = Sprite.load('objects/launch_station/launch_station_activated.png');
}