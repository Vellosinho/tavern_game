import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:projeto_gbb_demo/base_map.dart';
import 'package:projeto_gbb_demo/common/common.dart';
import 'package:projeto_gbb_demo/game.dart';
import 'package:projeto_gbb_demo/game/objects/bedroom/bed.dart';
import 'package:projeto_gbb_demo/game/objects/bedroom/chest.dart';
import 'package:projeto_gbb_demo/game/structs/change_map_transition.dart';
import 'package:projeto_gbb_demo/maps/tavern/tavern.dart';
import 'package:projeto_gbb_demo/players/controller/player_controller.dart';

class LivingRoomMap extends StatefulWidget {
  final LocalGameController gameController;
  final PlayerOneController playerOneController;
  const LivingRoomMap(
      {super.key,
      required this.gameController,
      required this.playerOneController});

  @override
  State<LivingRoomMap> createState() => _LivingRoomMapState();
}

class _LivingRoomMapState extends State<LivingRoomMap> {

  void sleep() {
    if (widget.gameController.playerCanSleep) {
      widget.gameController.disableVisibility(isBrightEnvironment: true);
      widget.gameController.skipDayOrNight();
      Future.delayed(Duration(seconds: 2), () {
        widget.gameController.enableVisibility();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<GameDecoration> bed = [
      BedBackground(position: Vector2(tileSize * 6.5, tileSize * 3.25), playerOneController: widget.playerOneController),
      BedForeground(position: Vector2(tileSize * 6.5, tileSize * 3.25), playerOneController: widget.playerOneController),
    ];
    return BaseMap(
        gameController: widget.gameController,
        playerOneController: widget.playerOneController,
        initDirection: Direction.up,
        map: WorldMapByTiled(
          WorldMapReader.fromAsset(
              'map/house_interior/yellow_house/player_house.json'),
          forceTileSize: Vector2(tileSize, tileSize),
        ),
        components: [
          Chest(playerOneController: widget.playerOneController, position: Vector2(tileSize * 3, tileSize * 3.5)),
          ...bed,
        ],
        initLocation: Vector2(tileSize * 2.5, tileSize * 10),
        locationActions: [
          LocationAction(
            coords: Vector2(tileSize * 2.5, tileSize * 11),
            orientation: TransitionOrientation.horizontal,
            destination: TavernMap(gameController: widget.gameController, playerOneController: widget.playerOneController,
              initPosition: Vector2(tileSize * 0.5, tileSize * 8), initDirection: Direction.down,
            ),
          ),
          LocationAction(
            coords: Vector2(tileSize * 7, tileSize * 3.25),
            orientation: TransitionOrientation.square,
            action: () {
              sleep();
            }
          ),
        ],
    );
  }
}
