import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:projeto_gbb_demo/base_map.dart';
import 'package:projeto_gbb_demo/common/common.dart';
import 'package:projeto_gbb_demo/game.dart';
import 'package:projeto_gbb_demo/game/structs/change_map_transition.dart';
import 'package:projeto_gbb_demo/maps/tavern/kitchen.dart';
import 'package:projeto_gbb_demo/maps/tavern/living_room.dart';
import 'package:projeto_gbb_demo/maps/town.dart';
import 'package:projeto_gbb_demo/players/controller/player_controller.dart';

class MainVillageMap extends StatefulWidget {
  final LocalGameController gameController;
  final PlayerOneController playerOneController;
  final Vector2? initPosition;
  final Direction? initDirection;
  const MainVillageMap(
    {
      super.key,
      required this.gameController,
      required this.playerOneController,
      this.initPosition,
      this.initDirection,
    });

  @override
  State<MainVillageMap> createState() => _MainVillageMapState();
}

class _MainVillageMapState extends State<MainVillageMap> {  
  @override
  Widget build(BuildContext context) {
      return BaseMap(
        gameController: widget.gameController,
        playerOneController: widget.playerOneController, 
        map: WorldMapByTiled(
          WorldMapReader.fromAsset(
            'map/main_village_map/main_village.json'),
          forceTileSize: Vector2(tileSize, tileSize),
        ),
        components: [],
        initLocation: widget.initPosition ?? Vector2(0,0),
        initDirection: widget.initDirection ?? Direction.up,
        locationActions: [
          // LocationAction(
          //   coords: Vector2(1268, 2739),
          //   orientation: TransitionOrientation.horizontal,
          //   destination: TownMap(
          //     gameController: widget.gameController,
          //     playerOneController: widget.playerOneController,
          //     // initPosition: Vector2(tileSize * 19, tileSize * 13),
          //     // initDirection: Direction.down,
          //   ),
          // ),
          // LocationAction(
          //   coords: Vector2(3013, 1900),
          //   orientation: TransitionOrientation.vertical,
          //   destination: KitchenMap(gameController: widget.gameController, playerOneController: widget.playerOneController),
          // ),
          // LocationAction(
          //   coords: Vector2(100, 1132),
          //   orientation: TransitionOrientation.horizontal,
          //   destination: LivingRoomMap(gameController: widget.gameController, playerOneController: widget.playerOneController),
          // ),
        ],
      );
  }
}
