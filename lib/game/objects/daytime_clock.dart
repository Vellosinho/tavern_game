import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:projeto_gbb_demo/game.dart';
import 'package:projeto_gbb_demo/game/controller/npc_controller.dart';
import 'package:projeto_gbb_demo/game/enum/enum_day_time.dart';
import 'package:projeto_gbb_demo/game/controller/game_controller.dart';
import 'package:projeto_gbb_demo/game/enum/weather.dart';
import 'package:projeto_gbb_demo/game/npcs/farmerNPC/farmer_npc.dart';
import 'package:projeto_gbb_demo/game/npcs/sheppardNPC/sheppard_npc.dart';
import 'package:projeto_gbb_demo/game/objects/object_sprites.dart';
import 'package:projeto_gbb_demo/game/objects/weather_objects/puddle.dart';
import 'package:projeto_gbb_demo/game/structs/npc_structure.dart';
import 'package:provider/provider.dart';

class DayTimeClock extends GameDecoration {
  LocalGameController localGameController;
  int stashedIron = 0;
  Weather lastWeather = Weather.clear;
  Function onStartRaining;
  DayTimeClock({required this.onStartRaining, required super.position, required this.localGameController})
      : super.withSprite(sprite: GameObjectsSprites.anvil, size: Vector2(0, 0));
  @override
  Future<void> onLoad() {
    // localGameController.startDaynightCycle();
    // updateNpcRoutine();
    updateGameLighting();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    // do anything
    super.update(dt);
  }

  // void updateGameLighting() {

  // gameRef.lighting!.animateToColor(localGameController.lightingColor, duration: Duration(seconds: 10));
  // }

  void updateGameLighting() {
    Future.delayed(Duration(seconds: 10), () {
      updateGameLighting();
      checkStartRaining();
    });
    switch (localGameController.daytime) {
      case DayTime.sunrise:
        gameRef.lighting!.animateToColor(Colors.orange[400]!.withAlpha(48),
            duration: Duration(seconds: 10));
        return;
      case DayTime.noon:
        gameRef.lighting!.animateToColor(Colors.orange[400]!.withAlpha(0),
            duration: Duration(seconds: 10));
        return;
      case DayTime.sunset:
        gameRef.lighting!.animateToColor(Colors.orange[400]!.withAlpha(48),
            duration: Duration(seconds: 10));
        return;
      case DayTime.night:
        gameRef.lighting!.animateToColor(Colors.indigo[900]!.withAlpha(148),
            duration: Duration(seconds: 10));
        return;
      default:
        return;
    }
  }

  void checkStartRaining() {
     
  List<Component> rainList = [
      Puddle(controller: localGameController, variation: 0, position: Vector2(tileSize * 15, tileSize * 3)),
      Puddle(controller: localGameController, variation: 1, position: Vector2(tileSize * 18, tileSize * 4)),
      Puddle(controller: localGameController, variation: 2, position: Vector2(tileSize * 11, tileSize * 9)),
      Puddle(controller: localGameController, variation: 3, position: Vector2(tileSize * 26, tileSize * 10)),
      Puddle(controller: localGameController, variation: 0, position: Vector2(tileSize * 6, tileSize * 11)),
      Puddle(controller: localGameController, variation: 1, position: Vector2(tileSize * 15, tileSize * 11)),
      Puddle(controller: localGameController, variation: 2, position: Vector2(tileSize * 3, tileSize * 12)),
      Puddle(controller: localGameController, variation: 3, position: Vector2(tileSize * 5, tileSize * 14)),
      Puddle(controller: localGameController, variation: 0, position: Vector2(tileSize * 14, tileSize * 14)),
      Puddle(controller: localGameController, variation: 1, position: Vector2(tileSize * 24, tileSize * 14)),
      Puddle(controller: localGameController, variation: 2, position: Vector2(tileSize * 25, tileSize * 15)),
      Puddle(controller: localGameController, variation: 3, position: Vector2(tileSize * 9, tileSize * 16)),
      Puddle(controller: localGameController, variation: 0, position: Vector2(tileSize * 2, tileSize * 17)),
      Puddle(controller: localGameController, variation: 1, position: Vector2(tileSize * 12, tileSize * 18)),
      Puddle(controller: localGameController, variation: 2, position: Vector2(tileSize * 22, tileSize * 19)),
      Puddle(controller: localGameController, variation: 3, position: Vector2(tileSize * 11, tileSize * 20)),
      Puddle(controller: localGameController, variation: 0, position: Vector2(tileSize * 25, tileSize * 20)),
  ];

    if (localGameController.currentWeather != lastWeather) {
      lastWeather = localGameController.currentWeather;
      if (lastWeather == Weather.rain) {
        // function();
        rainList.forEach((element) => gameRef.add(element));
      }
    }
  }

  void updateNpcRoutine() {
    int time = localGameController.getTime();

    List<NpcStructure> npcs =
        context.read<NPCController>().getSpawningNpcs(time);

    for (int i = 0; i < npcs.length; i++) {
      switch (npcs[i].profession) {
        case Profession.FARMER:
          gameRef.add(FarmerNPC(
              position: npcs[i].spawningLocation,
              initDirection: Direction.right,
              index: npcs[i].index,
              controller: localGameController,
              dialogue: npcs[i].dialogue));
          break;
        case Profession.SHEPPARD:
          gameRef.add(SheppardNPC(
              position: npcs[i].spawningLocation,
              initDirection: Direction.left,
              index: npcs[i].index,
              controller: localGameController,
              dialogue: npcs[i].dialogue));
          break;
        default:
      }
    }

    Future.delayed(Duration(seconds: 10), () {
      updateNpcRoutine();
    });
  }
}
