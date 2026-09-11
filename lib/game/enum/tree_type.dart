import 'dart:async';

import 'package:bonfire/bonfire.dart';
import 'package:projeto_gbb_demo/game/objects/object_sprites.dart';

enum TreeType {pine1, pine2, birch1, birch2}

FutureOr<Sprite> getTreeSprite(TreeType type) {
  switch (type) {
    case TreeType.pine1:
      return GameObjectsSprites.finePineTree;
    case TreeType.pine2:
      return GameObjectsSprites.finePine2Tree;
    case TreeType.birch1:
      return GameObjectsSprites.birch1Tree;
    case TreeType.birch2:
      return GameObjectsSprites.birch2Tree;
    default:
      return GameObjectsSprites.finePineTree;
  }
}

FutureOr<Sprite> getTreeShadow(TreeType type) {
  switch (type) {
    case TreeType.pine1:
      return GameObjectsSprites.finePineShadow;
    case TreeType.birch1:
      return GameObjectsSprites.birch1Shadow;
    case TreeType.birch2:
      return GameObjectsSprites.birch2Shadow;
    default:
      return GameObjectsSprites.finePineShadow;
  }
}