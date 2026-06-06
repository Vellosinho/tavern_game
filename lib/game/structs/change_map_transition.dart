import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';

class LocationAction {
  TransitionOrientation orientation;
  Vector2 coords;
  StatefulWidget? destination;
  Function? action;

  LocationAction({required this.coords, required this.orientation, this.destination, this.action});


  bool hitTransition(Vector2 value) {
    switch (orientation) {
      case TransitionOrientation.vertical: 
        if (((value.x - coords.x).abs() < 100) && ((value.y - coords.y).abs() < 500)) {
          return true;
        }
        break;
      case TransitionOrientation.horizontal: 
        if (((value.x - coords.x).abs() < 500) && ((value.y - coords.y).abs() < 100)) {
          return true;
        }
        break;
      case TransitionOrientation.square:
        if (((value.x - coords.x).abs() < 128) && ((value.y - coords.y).abs() < 128)) {
          return true;
        }
        break;
      default:
    }
    return false;
  }
}

enum TransitionOrientation {horizontal, vertical, square}