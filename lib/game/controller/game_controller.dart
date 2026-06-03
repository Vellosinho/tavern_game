import 'package:bonfire/bonfire.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:projeto_gbb_demo/common/common.dart';
import 'package:projeto_gbb_demo/game/enum/enum_day_time.dart';

class LocalGameController with ChangeNotifier {
  int hour = 06;
  int minute = 00;

  DayTime daytime = DayTime.sunrise;
  double _baseTemperature = 24; // -10 to 50C
  double _temperature = 24;
  double get temperature => _temperature;

  void setBaseTemperature(double value) {
    _baseTemperature = value;
  }

  double _temperatureModifier = 1.0;

  void setEnvironmentTemperature({required double environmentTemperature, required double modifier}) {
    _baseTemperature = environmentTemperature;
    _temperatureModifier = modifier;
    updateTemperature();
    notifyListeners();
  }

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
    updateTemperature();
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

    updateTemperature();
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
    updateTemperature();
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

  void updateTemperature() {
    switch(hour) {
      case 0:
        _temperature = _baseTemperature - (7 * _temperatureModifier);
        break;
      case 2:
        _temperature = _baseTemperature - (7 * _temperatureModifier);
        break;
      case 4:
        _temperature = _baseTemperature - (8 * _temperatureModifier);
        break;
      case 6:
        _temperature = _baseTemperature - (6 * _temperatureModifier);
        break;
      case 8:
        _temperature = _baseTemperature - (4 * _temperatureModifier);
        break;
      case 10:
        _temperature = _baseTemperature - (2 * _temperatureModifier);
        break;
      case 12:
        _temperature = _baseTemperature;
        break;
      case 14:
        _temperature = _baseTemperature - (2 * _temperatureModifier);
        break;
      case 16:
        _temperature = _baseTemperature - (3 * _temperatureModifier);
        break;
      case 18:
        _temperature = _baseTemperature - (5 * _temperatureModifier);
        break;
      case 20:
        _temperature = _baseTemperature - (6 * _temperatureModifier);
        break;
      case 22:
        _temperature = _baseTemperature - (7 * _temperatureModifier);
        break;
      case 23:
        _temperature = _baseTemperature - (7 * _temperatureModifier);
        break;
    }
    print("Update temperature: $_temperature C");
  }
}
