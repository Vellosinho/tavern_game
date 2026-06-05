import 'dart:io';
import 'dart:ui' as ui;
import 'package:bonfire/bonfire.dart';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as image;
import 'package:projeto_gbb_demo/common/common.dart';
import 'package:projeto_gbb_demo/game/enum/animationList.dart';
import 'package:projeto_gbb_demo/game/enum/one_time_animations.dart';
import 'package:projeto_gbb_demo/game/items/armor.dart';
import 'package:projeto_gbb_demo/game/items/base_item.dart';
import 'package:projeto_gbb_demo/game/structs/change_map_transition.dart';
import 'package:projeto_gbb_demo/players/player_one/weapons/weapon_type.dart';

class PlayerOneController with ChangeNotifier {

  bool _updateEquipment = false;
  bool get updateEquipment => _updateEquipment;
  bool gameIsPaused = false;
  bool minigameIsActive = false;
  bool _resetColision = false;
  bool get resetColision => _resetColision;
  Armor _currentArmor = griffinArmor;
  Armor get currentArmor => _currentArmor;
  double _environmentTemperature = 20;
  double _playerTemperature = 20;
  double get playerTemperature => _playerTemperature;
  double get temperatureModifier => currentArmor.temperatureModifier;

  void setCurrentArmor(Armor armor) {
    _currentArmor = armor;
  }

  double _playerLife = 100;
  double _playerStamina = 100;
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

  List<LocationAction> exitCoords = [];
  List<Function> exitFunctions = [];

  bool isCooldown = false;

  SpriteAnimation? _dashLeft;
  SpriteAnimation? get dashLeft => _dashLeft;
  SpriteAnimation? _dashFront;
  SpriteAnimation? get dashFront => _dashFront;
  SpriteAnimation? _dashRight; 
  SpriteAnimation? get dashRight => _dashRight; 
  SpriteAnimation? _dashBack;
  SpriteAnimation? get dashBack => _dashBack;

  SimpleDirectionAnimation? _currentPlayerEquipment;
  SimpleDirectionAnimation? get currentPlayerEquipment => _currentPlayerEquipment;

  void equipmentUpdated() {
    _updateEquipment = false;
  }

  void setCurrentPlayerAnimation(SimpleDirectionAnimation newAnimations) {
    _currentPlayerEquipment = newAnimations;
  }

  void setEnvironmentTemperature(double perceivedTemperature) {
    _environmentTemperature = perceivedTemperature;
    _playerTemperature = _environmentTemperature + temperatureModifier;
    notifyListeners();
  }

  void updateTemperature() {
    _playerTemperature = _environmentTemperature + temperatureModifier;
    notifyListeners();
  }

  void setPlayerDashAnimations(
   SpriteAnimation newDashLeft,
   SpriteAnimation newDashFront,
   SpriteAnimation newDashRight, 
   SpriteAnimation newDashBack, 
  ) {
    _dashLeft = newDashLeft;
    _dashFront = newDashFront;
    _dashRight = newDashRight;
    _dashBack = newDashBack;
    notifyListeners();
  }

  //remove later

  double get playerLife => _playerLife;
  double get playerStamina => _playerStamina;
  int get playerWallet => _playerWallet;
  int get playerFollowers => _playerFollowers;
  int get hitcount => _hitCount;
  WeaponType _weapon = WeaponType.sword;
  WeaponType get weapon => _weapon;

  
  void equipWeapon(WeaponType newWeapon) {
    _weapon = newWeapon;
    // weapon?.damage = 20;
    // damageType = DamageType.FIRE;
  }


  //Mini Game logic:
  int swordScore = 0;
  int minigameHitCount = 0;
  double timeCount = 0.0;
  Vector2 minigamePos = Vector2(0, 0);
  OneTimeAnimations _playAnimation = OneTimeAnimations.none;
  OneTimeAnimations get playAnimation => _playAnimation;

  int stashedIron = 0;

  void setImportantCoords({required List<LocationAction> newCoords, required List<Function> newFunctions}) {
    exitCoords = newCoords;
    exitFunctions = newFunctions;
  }

  void heal(int value) {
    ((_playerLife + value) > 20) ? _playerLife = 20 : _playerLife += value;
    notifyListeners();
  }

  void spendStamina(int value) {
    if (_playerStamina > value) {
      _playerStamina -= value;
    } else {
      _playerStamina = 0;
    }
    notifyListeners();
  }

  void recoverStamina() {
    if (_playerStamina <= 99) {
      _playerStamina++;
    }
    notifyListeners();
  }

  void hit(double value) {
    _playerLife -= value;
    print("playerLife: $_playerLife");
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

  void toggleResetCollision() {
    _resetColision = !_resetColision;
    notifyListeners();
  }

  void togglePaused() {
    gameIsPaused = !gameIsPaused;
    notifyListeners();
  }

  void checkImportantCoordsDistance(Vector2 currentPosition) {
    if (!isCooldown) {
      for (int i = 0; i < exitCoords.length; i++) {
        if (exitCoords[i].hitTransition(currentPosition)) {
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

  void turnOffAnimation() {
    _playAnimation = OneTimeAnimations.none;
    notifyListeners();
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


  void shrugPlayer() {
    _playAnimation = OneTimeAnimations.shrug;
  }

  Future<void> changeEquipment(Armor armor) async {
    SimpleDirectionAnimation newAnimations = await generateDirectionAnimation(armor.armorName);
    setCurrentPlayerAnimation(newAnimations);
    setCurrentArmor(armor);
    updateTemperature();
  }

  Future<SimpleDirectionAnimation> generateDirectionAnimation(String armor) async {
    List<SpriteAnimation> animations = [];

    image.Image? weapon;
    image.Image? base_player;
    image.Image? gear;
    image.Image? weapon_background = null;
    
    for (int i = 0; i < animationList.length; i++) {
      weapon = image.decodeImage(File('assets/images/weapons/griffin/${animationList[i]}.png').readAsBytesSync());
      base_player = image.decodeImage(File('assets/images/base_player/${animationList[i]}.png').readAsBytesSync());
      gear = image.decodeImage(File('assets/images/equipment/$armor/${animationList[i]}.png').readAsBytesSync());
      if (animationList[i].contains("dash") && (animationList[i].contains("front") || animationList[i].contains("back"))) {
        weapon_background = image.decodeImage(File('assets/images/weapons/griffin/${animationList[i]}_background.png').readAsBytesSync());
      }
      
      bool isRun = animationList[i].contains("walk");
      if (animationList[i].contains("dash")) {
        SpriteAnimation animation = await generateDashAnimation(
          base_player,
          weapon,
          gear,
          weapon_background,
          animationList[i]
        );
        animations.add(animation);
      } else {
        late Uint8List imageValue;
        if (animationList[i].contains("front") || animationList[i].contains("left")) {
          image.compositeImage(weapon!, base_player!,  dstX: 0);
          image.compositeImage(weapon, gear!,  dstX: 0);
          imageValue = image.encodePng(weapon);
        } else {
          image.compositeImage(base_player!, gear!,  dstX: 0);
          image.compositeImage(base_player, weapon!,  dstX: 0);
          imageValue = image.encodePng(base_player);
        }
        var spriteImage = await bytesToImage(imageValue);
          SpriteAnimation newAnimation = SpriteAnimation.fromFrameData(
            spriteImage,
            //amount: 6, stepTime: 0.075,
            SpriteAnimationData.sequenced(amount:isRun ? 6 : 4, stepTime: isRun ? 0.075 : 0.2, textureSize: Vector2(32,40))
          );  
        animations.add(newAnimation);
      }
      // image.compositeImage(mergedImage, base_player!,  dstX: 0);
    }
    setPlayerDashAnimations(
      animations[8],
      animations[9],
      animations[10],
      animations[11],
    );
    
    _updateEquipment = true;

    return SimpleDirectionAnimation(
      idleUp: animations[0],
      idleUpLeft: animations[0],
      idleUpRight: animations[0],
      idleDown: animations[1],
      idleDownLeft: animations[1],
      idleDownRight: animations[1],
      idleLeft: animations[2],
      idleRight: animations[3],
      runUp: animations[4],
      runUpRight: animations[4],
      runUpLeft: animations[4],
      runDown: animations[5],
      runDownRight: animations[5],
      runDownLeft: animations[5],
      runLeft: animations[6],
      runRight: animations[7],
    );
  }

  Future<SpriteAnimation> generateDashAnimation(
    image.Image? basePlayer,
    image.Image? weapon,
    image.Image? armor,
    image.Image? weapon_background,
    String label,
  ) async {
    late Uint8List imageValue;
    if(label.contains("left")) {
      image.compositeImage(weapon!, basePlayer!,  dstX: 0);
      image.compositeImage(weapon, armor!,  dstX: 0);
      imageValue = image.encodePng(weapon);
    } else if (label.contains("right")){
      image.compositeImage(basePlayer!, weapon!,  dstX: 0);
      image.compositeImage(basePlayer!, armor!,  dstX: 0);
      imageValue = image.encodePng(basePlayer);
    } else {
      image.compositeImage(weapon_background!, basePlayer!,  dstX: 0);
      image.compositeImage(weapon_background!, armor!,  dstX: 0);
      image.compositeImage(weapon_background, weapon!,  dstX: 0);
      imageValue = image.encodePng(weapon_background);
    }

    var spriteImage = await bytesToImage(imageValue);
    
    return SpriteAnimation.fromFrameData(
      spriteImage,
      SpriteAnimationData.sequenced(amount:7, stepTime: 0.075, textureSize: Vector2(32,40))
    );
  }

  Future<ui.Image> bytesToImage(Uint8List imgBytes) async {
    ui.Codec codec = await ui.instantiateImageCodec(imgBytes);
    ui.FrameInfo frame;
    try {
      frame = await codec.getNextFrame();
    } finally {
      codec.dispose();
    }
    return frame.image;
  }
}
