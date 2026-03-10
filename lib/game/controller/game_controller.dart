import 'dart:io';

import 'package:bonfire/bonfire.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as image;
import 'package:projeto_gbb_demo/common/common.dart';
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

  bool gameIsPaused = false;
  bool minigameIsActive = false;
  bool _resetColision = false;
  bool get resetColision => _resetColision;

  double _playerLife = 100;
  int _playerWallet = 0;
  int _playerFollowers = 0;
  int _hitCount = 0;
  final List<Item> _inventory = [
    Item(name: 'empty'),
    Item(name: 'empty'),
    Item(name: 'empty'),
    Item(name: 'empty'),
  ];
  List<Item> get inventory => _inventory;

  List<Vector2> exitCoords = [];
  List<Function> exitFunctions = [];

  bool isCooldown = false;

  SimpleDirectionAnimation? _currentPlayerEquipment;
  SimpleDirectionAnimation? get currentPlayerEquipment => _currentPlayerEquipment;

  void setCurrentPlayerAnimation(SimpleDirectionAnimation newAnimations) {
    _currentPlayerEquipment = newAnimations;
  }

  //remove later

  double get playerLife => _playerLife;
  int get playerWallet => _playerWallet;
  int get playerFollowers => _playerFollowers;
  int get hitcount => _hitCount;

  //Mini Game logic:
  int swordScore = 0;
  int minigameHitCount = 0;
  double timeCount = 0.0;
  Vector2 minigamePos = Vector2(0, 0);
  OneTimeAnimations _playAnimation = OneTimeAnimations.none;
  OneTimeAnimations get playAnimation => _playAnimation;

  int stashedIron = 0;

  void setImportantCoords({required List<Vector2> newCoords, required List<Function> newFunctions}) {
    exitCoords = newCoords;
    exitFunctions = newFunctions;
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

  void heal(int value) {
    ((_playerLife + value) > 20) ? _playerLife = 20 : _playerLife += value;
    notifyListeners();
  }

  void hit(double value) {
    _playerLife -= value;
    print("playerLife: $_playerLife");
    notifyListeners();
  }  
  
  void toggleResetCollision() {
    _resetColision = !_resetColision;
    notifyListeners();
  }

  void getMoney(int amount) {
    _playerWallet += amount;
    notifyListeners();
  }

  void spendMoney(int amount) {
    (_playerWallet - amount < 0) ? _playerWallet = 0 : _playerWallet -= amount;
    notifyListeners();
  }

  void playerFollowersAdd() {
    _playerFollowers++;
    notifyListeners();
  }

  void addHitCount() {
    _hitCount++;
    Future.delayed(const Duration(seconds: 3), () {
      _hitCount--;
    });
  }

  void addArrowHitCount() {
    _hitCount--;
    Future.delayed(const Duration(seconds: 3), () {
      _hitCount++;
    });
  }

  void togglePaused() {
    gameIsPaused = !gameIsPaused;
    notifyListeners();
  }

  bool getIron(ironCount) {
    if (!isInventoryFull() && (ironCount > 0)) {
      addToInventory(IronBar());
      stashedIron--;
      _playAnimation = OneTimeAnimations.acquiredIron;
      notifyListeners();
      return true;
    } else {
      shrugPlayer();
      notifyListeners();
      return false;
    }
  }

  // Smithing Table functions:

  void getWeapon() {
    _playAnimation = OneTimeAnimations.acquiredHammer;
    notifyListeners();
  }

  // Anvil functions:

  void startMinigame(Vector2 pos, double damage) {
    if (hasIron() && damage >= 15) {
      removeFromInventory(IronBar());
      minigameHitCount = 0;
      swordScore = 0;
      minigameIsActive = true;
      minigamePos = pos;
      startGameLoopCounter();
      notifyListeners();
    } else {
      shrugPlayer();
    }
  }

  void miniGameHit() {
    if (minigameHitCount < 4) {
      setSwordScore(sin(timeCount));
      minigameHitCount++;
    } else {
      setSwordScore(sin(timeCount));
      if (swordScore >= 170) {
        _playAnimation = (swordScore == 250)
            ? OneTimeAnimations.perfectSwordComplete
            : OneTimeAnimations.swordComplete;
        // swords.add(ForgedSword(swordScore: swordScore, isLegendary: (swordScore == 250)));
        addToInventory(Sword(isLegenday: swordScore >= 250));
      }
      minigameIsActive = false;
    }
    notifyListeners();
  }

  void checkMinigameDistance(Vector2 currentPosition) {
    if (minigameIsActive) {
      if (((currentPosition.x - minigamePos.x > 320) ||
              (currentPosition.x - minigamePos.x < -320)) ||
          ((currentPosition.y - minigamePos.y > 320) ||
              (currentPosition.y - minigamePos.y < -320))) {
        cancelMinigame();
        notifyListeners();
      }
    }
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

  void cancelMinigame() {
    minigameIsActive = false;
    notifyListeners;
  }

  void turnOffAnimation() {
    _playAnimation = OneTimeAnimations.none;
    notifyListeners();
  }

  Future<void> startGameLoopCounter() async {
    Random rand = Random();
    double randVelocity = (rand.nextInt(75) + 50) / 1000;
    timeCount = 0;
    while (minigameIsActive) {
      await Future.delayed(const Duration(milliseconds: 25), () {
        timeCount = timeCount + randVelocity; //Increment Counter
      });
      notifyListeners();
    }
  }

  void setSwordScore(double value) {
    if (value < 0) {
      value = value * -1;
    }

    if (value > 0.45) {
      swordScore += 10;
    } else if (value > 0.15) {
      swordScore += 25;
    } else {
      swordScore += 50;
    }
  }

  int getTime() {
    int time = (hour * 100) + minute;
    return time;
  }

  // Inventory Functions:

  void addToInventory(Item itemToAdd) {
    // _inventory.firstWhere((element) => element.name == 'empty');
    if (_inventory[0].name == 'empty') {
      _inventory[0] = itemToAdd;
    } else if (_inventory[1].name == 'empty') {
      _inventory[1] = itemToAdd;
    } else if (_inventory[2].name == 'empty') {
      _inventory[2] = itemToAdd;
    } else if (_inventory[3].name == 'empty') {
      _inventory[3] = itemToAdd;
    }
    notifyListeners();
  }

  void removeFromInventory(Item itemToRemove) {
    // _inventory.firstWhere((element) => element.name == 'empty');
    if (_inventory[0].name == itemToRemove.name) {
      _inventory[0] = Item(name: 'empty');
    } else if (_inventory[1].name == itemToRemove.name) {
      _inventory[1] = Item(name: 'empty');
    } else if (_inventory[2].name == itemToRemove.name) {
      _inventory[2] = Item(name: 'empty');
    } else if (_inventory[3].name == itemToRemove.name) {
      _inventory[3] = Item(name: 'empty');
    }
    notifyListeners();
  }

  bool hasIron() {
    bool hasIron = false;
    for (int i = 0; i < 4; i++) {
      if (_inventory[i].name == 'ironBar') {
        hasIron = true;
      }
    }
    return hasIron;
  }

  bool isInventoryFull() {
    bool full = true;
    for (int i = 0; i < 4; i++) {
      if (_inventory[i].name == 'empty') {
        full = false;
      }
    }
    return full;
  }

  Item? getFirstOfType(Item type) {
    int pos = -1;
    for (int i = 0; i < 4; i++) {
      if (_inventory[i].name == type.name) {
        pos = i;
        break;
      }
    }
    if (pos == -1) {
      return null;
    }
    return _inventory[pos];
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

    // Future.delayed(Duration(seconds: 10), () {
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

  void shrugPlayer() {
    _playAnimation = OneTimeAnimations.shrug;
  }

  void createPlayerSprite() {
    final image1 = image.decodeImage(File('assets/images/communist/blacksmith/unarmed/blacksmith_idle_front.png').readAsBytesSync());
    final image2 = image.decodeImage(File('assets/images/equipment/black_pearl/idle_front.png').readAsBytesSync());
    // image.compositeImage(mergedImage, image1!,  dstX: 0);
    image.compositeImage(image1!, image2!,  dstX: 0);
    final file = new File("assets/images/player/merged_image.png");
    file.writeAsBytesSync(image.encodePng(image1));
    // imageCache.clear();
  }
}
