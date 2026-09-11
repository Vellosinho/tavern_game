import 'package:bonfire/bonfire.dart';
import 'package:projeto_gbb_demo/game/enum/tree_type.dart';
import 'package:projeto_gbb_demo/game/objects/object_sprites.dart';

List<GameComponent> tree({required Vector2 position, required TreeType type}) => [
  Tree(position: position, type: type),
  _shadow(position: position, type: type),
];

class Tree extends GameDecoration with Attackable {
  TreeType type;
  Tree({required super.position, required this.type})
      : super.withSprite(sprite: getTreeSprite(type), size: Vector2(384, 576))
  ;
  @override
  Future<void> onLoad() async {
    add(RectangleHitbox(
      size: Vector2(64, 128),
      position: Vector2(148, 440),
    ));
    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
  }

  @override
  void onReceiveDamage(attacker, double damage, identify, damageType) {
    super.onReceiveDamage(attacker, 0.0, identify, damageType);
  }
}
class _shadow extends GameDecoration with Attackable {
  TreeType type;
  _shadow({required super.position, required this.type})
      : super.withSprite(
            sprite: getTreeShadow(type), size: Vector2(384, 576));
  @override
  Future<void> onLoad() async {
    add(RectangleHitbox(
      size: Vector2(384, 0),
      position: Vector2(0, 0),
    ));
    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
  }

  @override
  void onReceiveDamage(attacker, double damage, identify, damageType) {
    super.onReceiveDamage(attacker, 0.0, identify, damageType);
  }
}
