import 'dart:async';

import 'package:bonfire/bonfire.dart';
import 'package:projeto_gbb_demo/game/objects/object_sprites.dart';

enum BushType {
  bush1, bush2
}

FutureOr<Sprite> getBushSprite(BushType type) {
  switch (type) {
    case BushType.bush1:
      return GameObjectsSprites.bush1;
    case BushType.bush2:
      return GameObjectsSprites.bush2;
    default:
      return GameObjectsSprites.bush1;
  }
}

FutureOr<Sprite> getBushShadow(BushType type) {
  switch (type) {
    case BushType.bush1:
      return GameObjectsSprites.bush1Shadow;
    case BushType.bush2:
      return GameObjectsSprites.bush2Shadow;
    default:
      return GameObjectsSprites.bush1Shadow;
  }
}