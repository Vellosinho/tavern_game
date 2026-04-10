import 'dart:io';
import 'dart:ui' as ui;

import 'package:bonfire/bonfire.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as image;
import 'package:projeto_gbb_demo/common/common.dart';
import 'package:projeto_gbb_demo/game/enum/animationList.dart';
import 'package:projeto_gbb_demo/game/enum/enum_day_time.dart';
import 'package:projeto_gbb_demo/game/enum/one_time_animations.dart';
import 'package:projeto_gbb_demo/game/items/base_item.dart';
import 'package:projeto_gbb_demo/game/items/iron_item.dart';
import 'package:projeto_gbb_demo/game/items/sword_item.dart';
import 'dart:math';

class LocalGameController with ChangeNotifier {
  int hour = 06;
  // int hour = 6
  int minute = 00;

  DayTime daytime = DayTime.sunrise;

  Color mapTintColor = Colors.orange[400]!.withAlpha(48);
  Color _visibilityScreen = Colors.black;
  Color get visibilityScreen => _visibilityScreen;

  bool _updateEquipment = false;
  bool get updateEquipment => _updateEquipment;
  bool gameIsPaused = false;
  bool minigameIsActive = false;
  bool _resetColision = false;
  bool get resetColision => _resetColision;

  void toggleResetCollision() {
    _resetColision = !_resetColision;
    notifyListeners();
  }

  List<Vector2> exitCoords = [];
  List<Function> exitFunctions = [];

  bool isCooldown = false;

  void setImportantCoords({required List<Vector2> newCoords, required List<Function> newFunctions}) {
    exitCoords = newCoords;
    exitFunctions = newFunctions;
  }
  
  void checkImportantCoordsDistance(Vector2 currentPosition) {
    if (!isCooldown) {
      for (int i = 0; i < exitCoords.length; i++) {
        if (((currentPosition.x - exitCoords[i].x).abs() < 300) &&
              ((currentPosition.y - exitCoords[i].y).abs() < 100)) {
            // print("Teste");
            exitFunctions[i]();
            isCooldown = true;
            Future.delayed(Duration(milliseconds: 500), () {
              isCooldown = false;
            });
        }
      }
    }
  }

  void enableVisibility() {
    Future.delayed(Duration(milliseconds: 250), () {
      _visibilityScreen = _visibilityScreen.withAlpha(0);
      notifyListeners();
    });
  }

  void disableVisibility({bool? isBrightEnvironment}) {
    // _visibilityScreen = (isBrightEnvironment ?? false) ? (getOutsideColor() ?? Colors.white.withAlpha(255)) : Colors.black.withAlpha(255);
    _visibilityScreen = Colors.black.withAlpha(255);
    notifyListeners();
  }

  int getTime() {
    int time = (hour * 100) + minute;
    return time;
  }

  void startDaynightCycle() {
    Future.delayed(Duration(seconds: 10), () {
      passMinute();
    });
  }

  void passMinute() {
    print("$hour:$minute");
    if (minute > 40) {
      passHour();
      minute = 00;
    } else {
      minute += 10;
    }

    Future.delayed(Duration(seconds: 10), () {
      passMinute();
    });
  }

  void passHour() {
    if (hour > 22) {
      hour = 00;
    } else {
      hour++;
    }
    updateShading();
  }

  void updateShading() {
    Color nightColor = Colors.indigo[900]!.withAlpha(148);
    Color sunRiseColor = Colors.orange[400]!.withAlpha(48);
    Color noonColor = Colors.orange[400]!.withAlpha(0);

    switch (hour) {
      case 6:
        mapTintColor = sunRiseColor;
        daytime = DayTime.sunrise;
        break;
      case 7:
        mapTintColor = noonColor;
        daytime = DayTime.noon;
        break;
      case 18:
        mapTintColor = sunRiseColor;
        daytime = DayTime.sunset;
        break;
      case 19:
        mapTintColor = nightColor;
        daytime = DayTime.night;
        break;
    }
    notifyListeners();
  }

  Color? getOutsideColor() {
    switch (daytime) {
      case DayTime.sunrise:
        return Colors.orange[400];
      case DayTime.noon:
        return Colors.yellow[100];
      case DayTime.sunset:
        return Colors.orange[400];
      case DayTime.night:
        return Colors.indigo[900];
    }
  }
}
