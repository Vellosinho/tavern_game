import 'package:bonfire/bonfire.dart';
import 'package:projeto_gbb_demo/game/enum/bush_type.dart';

List<GameComponent> bush({required Vector2 position, required BushType type}) => [
  Bush(position: position, type: type),
  _shadow(position: position, type: type),
];

class Bush extends GameDecoration with Attackable {
  BushType type;
  Bush({required super.position, required this.type})
      : super.withSprite(sprite: getBushSprite(type), size: Vector2(384, 576))
  ;
  @override
  Future<void> onLoad() async {
    add(RectangleHitbox(
      size: Vector2(64, 64),
      position: Vector2(148, 504),
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
  BushType type;
  _shadow({required super.position, required this.type})
      : super.withSprite(
            sprite: getBushShadow(type), size: Vector2(384, 576));
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
