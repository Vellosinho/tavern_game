import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:projeto_gbb_demo/base_map.dart';
import 'package:projeto_gbb_demo/common/common.dart';
import 'package:projeto_gbb_demo/game.dart';
import 'package:projeto_gbb_demo/game/enum/bush_type.dart';
import 'package:projeto_gbb_demo/game/enum/tree_type.dart';
import 'package:projeto_gbb_demo/game/objects/daytime_clock.dart';
import 'package:projeto_gbb_demo/game/objects/plants/bush.dart';
import 'package:projeto_gbb_demo/game/objects/plants/tree.dart';
import 'package:projeto_gbb_demo/game/structs/change_map_transition.dart';
import 'package:projeto_gbb_demo/maps/main_village/main_village_objects/waterfall.dart';
import 'package:projeto_gbb_demo/maps/garden.dart';
import 'package:projeto_gbb_demo/parallax/parallax_clouds.dart';
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
        isOutside: true,
        backgroundColor: Color(0xff6ab0d0),
        background: BonfireParallaxRiverBackground(),
        gameController: widget.gameController,
        playerOneController: widget.playerOneController, 
        map: WorldMapByTiled(
          WorldMapReader.fromAsset(
            'map/main_village_map/main_village.json'),
          forceTileSize: Vector2(tileSize, tileSize),
        ),
        components: [
          //trees:
          ...tree(position: Vector2(tileSize * 19, tileSize * 2), type: TreeType.birch2),
          ...tree(position: Vector2(tileSize * 13, tileSize * 3), type: TreeType.birch1),
          ...tree(position: Vector2(tileSize * 0, tileSize * 1), type: TreeType.birch1),
          ...tree(position: Vector2(tileSize * 1, tileSize * 3.5), type: TreeType.birch2),
          ...tree(position: Vector2(tileSize * 3, tileSize * 0.25), type: TreeType.pine2),
          ...tree(position: Vector2(tileSize * 5, tileSize * 4.5), type: TreeType.pine1),
          ...tree(position: Vector2(tileSize * 4, tileSize * 3.5), type: TreeType.birch1),
          ...tree(position: Vector2(tileSize * 3, tileSize * 5.5), type: TreeType.pine2),
          ...tree(position: Vector2(tileSize * 6, tileSize * 8), type: TreeType.birch1),
          ...tree(position: Vector2(tileSize * 8, tileSize * 7), type: TreeType.birch2),
          //bushes:
          ...bush(position: Vector2(tileSize * 0.5, tileSize * 4.25), type: BushType.bush2),
          ...bush(position: Vector2(tileSize * 17, tileSize * 1.75), type: BushType.bush2),
          ...bush(position: Vector2(tileSize * 3.5, tileSize * 4), type: BushType.bush1),
          ...bush(position: Vector2(tileSize * 13, tileSize * 3.25), type: BushType.bush1),
          ...bush(position: Vector2(tileSize * 5.5, tileSize * 7.5), type: BushType.bush2),
          // Tree(position: Vector2(0, 0)),x
          Waterfall(position: Vector2(tileSize * 47, 0)),
          DayTimeClock(
            onStartRaining: () {
            // this.add(rainList);
            },
            position: Vector2(0,0), localGameController: widget.gameController
          ),
        ],
        initPosition: widget.initPosition ?? Vector2(0,0),
        initDirection: widget.initDirection ?? Direction.up,
        locationActions: [
          LocationAction(
            coords: Vector2(1812, -100),
            orientation: TransitionOrientation.horizontal,
            destination: GardenMap(
              gameController: widget.gameController,
              playerOneController: widget.playerOneController,
              initPosition: Vector2(tileSize * 15, tileSize * 28),
              initDirection: Direction.up,
            ),
          ),
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
