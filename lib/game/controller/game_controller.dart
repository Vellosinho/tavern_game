import 'dart:math';

import 'package:bonfire/bonfire.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:projeto_gbb_demo/common/common.dart';
import 'package:projeto_gbb_demo/game/enum/enum_day_time.dart';
import 'package:projeto_gbb_demo/game/enum/season.dart';
import 'package:projeto_gbb_demo/game/enum/weather.dart';

class LocalGameController with ChangeNotifier {
  int _hour = 06;
  int get hour => _hour;
  int _minute = 00;
  int get minute => _minute;
  int _day = 1;
  int get day => _day;
  int year = 1;

  int _riskOfRain = 5;

  Season _currentSeason = Season.spring;
  Season get currentSeason => _currentSeason;

  bool _isSkippingDayOrNight = false;


  DayTime daytime = DayTime.sunrise;
  double _baseTemperature = 24; // -10 to 50C
  double _temperatureModifier = 0; // -10 to 50C
  double _temperature = 24;
  double get temperature => _temperature;
  Weather _currentWeather = Weather.clear;
  Weather get currentWeather => _currentWeather;

  void setBaseTemperature(double value) {
    _baseTemperature = value;
  }

  void _rerollRiskOfRain() {
    _riskOfRain = Random().nextInt(100);
  }

  double _temperatureRangeModifier = 1.0;

  void setEnvironmentTemperature({required double environmentTemperature, required double modifier, required bool isOutside}) {
    _baseTemperature = environmentTemperature;
    if (isOutside && (_currentWeather == Weather.rain)) {
      _temperatureModifier = -4;
    } else {
      _temperatureModifier = 0;
    }
    _temperatureRangeModifier = modifier;
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
  bool _playerCanSleep = true;
  bool get playerCanSleep => _playerCanSleep;
  
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
    int time = (_hour * 100) + _minute;
    return time;
  }

  void startDaynightCycle() {
    updateTemperature();
    Future.delayed(Duration(seconds: 10), () {
      _passMinute();
    });
  }

  void skipDayOrNight() {
    _playerCanSleep = false;
    _isSkippingDayOrNight = true;
    if (_hour >= 6 &&_hour < 18) {
      _hour = 18;
    } else {
      _passDay();
      _hour = 6;
    }
    _minute = 0;
    _isSkippingDayOrNight = false;
    updateShading();
    notifyListeners();

    Future.delayed(Duration(minutes: 1), () {
      _playerCanSleep = true;
    });
  }

  void _passMinute() {
    if (!_isSkippingDayOrNight) {
      print("$_hour:$_minute");
      if (_minute > 40) {
        _passHour();
        _minute = 00;
      } else {
        _minute += 10;
      }
    }

    updateTemperature();
    Future.delayed(Duration(seconds: 10), () {
        _passMinute();
    });
  }

  void _passHour() {
    if (_hour > 22) {
      _hour = 00;
      _passDay();
    } else {
      _hour++;
    }
    updateShading();
  }

  void _rerollWeather() {
    int willRain = Random().nextInt(100);
    print("Rerolling weather, $willRain");
    if (willRain < _riskOfRain) {
      if (_currentWeather != Weather.rain) {
        startRain();
      }
    } else {
      if (_currentWeather != Weather.clear) {
        _stopRain();
      }
    }
  }

  void startRain() {
      _currentWeather = Weather.rain;
      _temperatureModifier = -4;
      _temperatureRangeModifier += 1;
  }

  void _stopRain() {
      _currentWeather = Weather.clear;
      _temperatureModifier = 0;
      _temperatureRangeModifier -= 1;
  }

  void _passDay() {
    _day++;
    print("Dia: $_day");
    _rerollRiskOfRain();
  }

  void updateShading() {
    Color nightColor = Colors.indigo[900]!.withAlpha(148);
    Color sunRiseColor = Colors.orange[400]!.withAlpha(48);
    Color noonColor = Colors.orange[400]!.withAlpha(0);

    // _rerollWeather();

    switch (_hour) {
      case 6:
        _rerollWeather();
        mapTintColor = sunRiseColor;
        daytime = DayTime.sunrise;
        break;
      case 7:
        mapTintColor = noonColor;
        daytime = DayTime.noon;
        break;
      case 12:
        _rerollWeather();
        break;
      case 18:
        _rerollWeather();
        mapTintColor = sunRiseColor;
        daytime = DayTime.sunset;
        break;
      case 19:
        mapTintColor = nightColor;
        daytime = DayTime.night;
        break;
      case 0:
        _rerollWeather();
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
    switch(_hour) {
      case 0:
        _temperature = (_baseTemperature + _temperatureModifier) - (7 * _temperatureRangeModifier);
        break;
      case 2:
        _temperature = (_baseTemperature + _temperatureModifier) - (7 * _temperatureRangeModifier);
        break;
      case 4:
        _temperature = (_baseTemperature + _temperatureModifier) - (8 * _temperatureRangeModifier);
        break;
      case 6:
        _temperature = (_baseTemperature + _temperatureModifier) - (6 * _temperatureRangeModifier);
        break;
      case 8:
        _temperature = (_baseTemperature + _temperatureModifier) - (4 * _temperatureRangeModifier);
        break;
      case 10:
        _temperature = (_baseTemperature + _temperatureModifier) - (2 * _temperatureRangeModifier);
        break;
      case 12:
        _temperature = (_baseTemperature + _temperatureModifier);
        break;
      case 14:
        _temperature = (_baseTemperature + _temperatureModifier) - (2 * _temperatureRangeModifier);
        break;
      case 16:
        _temperature = (_baseTemperature + _temperatureModifier) - (3 * _temperatureRangeModifier);
        break;
      case 18:
        _temperature = (_baseTemperature + _temperatureModifier) - (5 * _temperatureRangeModifier);
        break;
      case 20:
        _temperature = (_baseTemperature + _temperatureModifier) - (6 * _temperatureRangeModifier);
        break;
      case 22:
        _temperature = (_baseTemperature + _temperatureModifier) - (7 * _temperatureRangeModifier);
        break;
      case 23:
        _temperature = (_baseTemperature + _temperatureModifier) - (7 * _temperatureRangeModifier);
        break;
    }

    print("Temperatura: $_temperature, modifier: $_temperatureModifier, rangeModifier: $_temperatureRangeModifier, hour: $_hour, weather: ${_currentWeather.name}");
  }
}
