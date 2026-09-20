import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:projeto_gbb_demo/base_map.dart';
import 'package:projeto_gbb_demo/common/common.dart';
import 'package:projeto_gbb_demo/game.dart';
import 'package:projeto_gbb_demo/game/structs/change_map_transition.dart';
import 'package:projeto_gbb_demo/maps/main_village/main_village.dart';
import 'package:projeto_gbb_demo/maps/tavern/kitchen.dart';
import 'package:projeto_gbb_demo/maps/tavern/living_room.dart';
import 'package:projeto_gbb_demo/maps/garden.dart';
import 'package:projeto_gbb_demo/players/controller/player_controller.dart';

class SmallYellowHouse extends StatefulWidget {
  final LocalGameController gameController;
  final PlayerOneController playerOneController;
  final Vector2? initPosition;
  final Direction? initDirection;
  const SmallYellowHouse(
    {
      super.key,
      required this.gameController,
      required this.playerOneController,
      this.initPosition,
      this.initDirection,
    });

  @override
  State<SmallYellowHouse> createState() => _SmallYellowHouseState();
}

class _SmallYellowHouseState extends State<SmallYellowHouse> {  
  @override
  Widget build(BuildContext context) {
      return BaseMap(
        gameController: widget.gameController,
        playerOneController: widget.playerOneController, 
        map: WorldMapByTiled(
          WorldMapReader.fromAsset(
            'map/main_village_map/interior_maps/small_yellow_house.json'),
          forceTileSize: Vector2(tileSize, tileSize),
        ),
        components: [],
        initPosition: widget.initPosition ?? Vector2(0,0),
        initDirection: widget.initDirection ?? Direction.up,
        locationActions: [
          LocationAction(
            coords: Vector2(1268, 3200),
            orientation: TransitionOrientation.horizontal,
            isBrightEnvironment: true,
            destination: MainVillageMap(
              gameController: widget.gameController,
              playerOneController: widget.playerOneController,
              initPosition: Vector2(tileSize * 49, tileSize * 40.25),
              initDirection: Direction.down,
            ),
          ),
        ],
      );
  }
}
