import 'package:bonfire/bonfire.dart';

class ChangeMapTransition {
  TransitionOrientation orientation;
  Vector2 coords;

  ChangeMapTransition({required this.coords, required this.orientation});


  bool hitTransition(Vector2 value) {
    if (orientation == TransitionOrientation.vertical) {
      if (((value.x - coords.x).abs() < 100) && ((value.y - coords.y).abs() < 500)) {
        return true;
      }
    } else {
      if (((value.x - coords.x).abs() < 500) && ((value.y - coords.y).abs() < 100)) {
        return true;
      }
    }
    return false;
  }
}

enum TransitionOrientation {horizontal, vertical}