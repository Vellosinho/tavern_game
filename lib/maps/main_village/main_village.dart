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
import 'package:projeto_gbb_demo/maps/main_village/main_village_interior_maps/blacksmith_house/blacksmith_house.dart';
import 'package:projeto_gbb_demo/maps/main_village/main_village_interior_maps/church/church.dart';
import 'package:projeto_gbb_demo/maps/main_village/main_village_interior_maps/yellow_house/small_yellow_house.dart';
import 'package:projeto_gbb_demo/maps/main_village/main_village_objects/waterfall.dart';
import 'package:projeto_gbb_demo/maps/garden.dart';
import 'package:projeto_gbb_demo/maps/tavern/components/exit_mat.dart';
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

    goTo({required StatefulWidget destination}) {
    widget.gameController.disableVisibility(isBrightEnvironment: false);
      Future.delayed(Duration(milliseconds: 1000), () {
      widget.playerOneController.toggleResetCollision();
      Future.delayed(Duration(milliseconds: 150), () {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => destination,
            transitionDuration: Duration(milliseconds: 1),
            reverseTransitionDuration: Duration(milliseconds: 1),
          ),
        );
      });});
  }

  /*
   // blacksmith:
     initPosition: Vector2(tileSize * 46, tileSize * 27),
     */

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
          ...tree(position: Vector2(tileSize * 1, tileSize * 3.5), type: TreeType.birch2),
          ...tree(position: Vector2(tileSize * 3, tileSize * 0.25), type: TreeType.pine2),
          ...tree(position: Vector2(tileSize * 5, tileSize * 4.5), type: TreeType.pine1),
          ...tree(position: Vector2(tileSize * 3, tileSize * 5.5), type: TreeType.pine2),
          ...tree(position: Vector2(tileSize * 6, tileSize * 8), type: TreeType.birch1),
          ...tree(position: Vector2(tileSize * 30, tileSize * 15), type: TreeType.apple1),
          ...tree(position: Vector2(tileSize * 12, tileSize * 0), type: TreeType.pine1),
          ...tree(position: Vector2(tileSize * 42.5, tileSize * 14), type: TreeType.pine1),
          ...tree(position: Vector2(tileSize * 42.5, tileSize * 15), type: TreeType.pine2),
          // ...tree(position: Vector2(tileSize * 42.5, tileSize * 16), type: TreeType.pine1),
          ...tree(position: Vector2(tileSize * 22.25, tileSize * 13.75), type: TreeType.pine1),
          ...tree(position: Vector2(tileSize * 20, tileSize * 22), type: TreeType.pine1),
          ...tree(position: Vector2(tileSize * 24, tileSize * 21), type: TreeType.birch1),
          // ...tree(position: Vector2(tileSize * 21, tileSize * 26), type: TreeType.pine2),
          ...tree(position: Vector2(tileSize * 25, tileSize * 27), type: TreeType.pine1),
          ...tree(position: Vector2(tileSize * 28, tileSize * 35), type: TreeType.birch2),
          // ...tree(position: Vector2(tileSize * 31, tileSize * 36), type: TreeType.birch1),
          ...tree(position: Vector2(tileSize * 22, tileSize * 33), type: TreeType.pine1),
          ...tree(position: Vector2(tileSize * 16.75, tileSize * 24.5), type: TreeType.birch2),
          ...tree(position: Vector2(tileSize * 16.75, tileSize * 24.5), type: TreeType.birch2),
          ...tree(position: Vector2(tileSize * 23.5, tileSize * 35.5), type: TreeType.pine2),
          // ...tree(position: Vector2(tileSize * 26.5, tileSize * 17.25), type: TreeType.pine2),
          ...tree(position: Vector2(tileSize * 29, tileSize * 8.75), type: TreeType.birch2),
          ...tree(position: Vector2(tileSize * 23, tileSize * 3.5), type: TreeType.pine1),
          ...tree(position: Vector2(tileSize * 11.5, tileSize * 11.25), type: TreeType.birch2),
          ...tree(position: Vector2(tileSize * 43.5, tileSize * 34), type: TreeType.birch2),
          ...tree(position: Vector2(tileSize * 36.5, tileSize * 31), type: TreeType.pine2),
          ...tree(position: Vector2(tileSize * 37, tileSize * 34), type: TreeType.birch2),
          ...tree(position: Vector2(tileSize * 56.5, tileSize * 26.25), type: TreeType.birch1),
          ...tree(position: Vector2(tileSize * 55.75, tileSize * 7), type: TreeType.birch1),
          ...tree(position: Vector2(tileSize * 59.75, tileSize * 8.25), type: TreeType.birch1),
          ...tree(position: Vector2(tileSize * 47, tileSize * 14.25), type: TreeType.birch1),
          ...tree(position: Vector2(tileSize * 51, tileSize * 11.5), type: TreeType.pine2),
          ...tree(position: Vector2(tileSize * 54, tileSize * 12.5), type: TreeType.birch2),
          ...tree(position: Vector2(tileSize * 60.25, tileSize * 23.5), type: TreeType.birch1),
          ...tree(position: Vector2(tileSize * 62.25, tileSize * 27.25), type: TreeType.birch1),
          ...tree(position: Vector2(tileSize * 62, tileSize * 12), type: TreeType.pine2),
          ...tree(position: Vector2(tileSize * 50, tileSize * 22), type: TreeType.pine2),
          ...tree(position: Vector2(tileSize * 52, tileSize * 24.5), type: TreeType.birch2),
          ...tree(position: Vector2(tileSize * 45.5, tileSize * 30.25), type: TreeType.birch1),
          ...tree(position: Vector2(tileSize * 51.5, tileSize * 29), type: TreeType.birch1),
          ...tree(position: Vector2(tileSize * 53, tileSize * 30), type: TreeType.pine1),
          ...tree(position: Vector2(tileSize * 44, tileSize * 20.25), type: TreeType.pine1),
          ...tree(position: Vector2(tileSize * 45.5, tileSize * 37.5), type: TreeType.pine2),
          ...tree(position: Vector2(tileSize * 51.5, tileSize * 37.5), type: TreeType.pine1),
          //
          ...tree(position: Vector2(tileSize * 4, tileSize * 20), type: TreeType.birch2),
          ...tree(position: Vector2(tileSize * 2, tileSize * 30), type: TreeType.birch1),
          ...tree(position: Vector2(tileSize * 9.5, tileSize * 21), type: TreeType.pine2),
          ...tree(position: Vector2(tileSize * 5, tileSize * 20.5), type: TreeType.pine1),
          //bushes:
          ...bush(position: Vector2(tileSize * 0.5, tileSize * 4.25), type: BushType.bush2),
          ...bush(position: Vector2(tileSize * 17, tileSize * 1.75), type: BushType.bush2),
          ...bush(position: Vector2(tileSize * 3.5, tileSize * 4), type: BushType.bush1),
          ...bush(position: Vector2(tileSize * 13, tileSize * 3.25), type: BushType.bush1),
          ...bush(position: Vector2(tileSize * 36.75, tileSize * 9.5), type: BushType.bush1),
          ...bush(position: Vector2(tileSize * 34.5, tileSize * 16.5), type: BushType.bush2),
          ...bush(position: Vector2(tileSize * 22, tileSize * 14), type: BushType.bush2),
          ...bush(position: Vector2(tileSize * 21, tileSize * 22.5), type: BushType.bush2),
          ...bush(position: Vector2(tileSize * 20.5, tileSize * 26.5), type: BushType.bush1),
          ...bush(position: Vector2(tileSize * 28.5, tileSize * 37), type: BushType.bush2),
          ...bush(position: Vector2(tileSize * 29, tileSize * 36.5), type: BushType.bush1),
          ...bush(position: Vector2(tileSize * 24, tileSize * 35.25), type: BushType.bush1),
          ...bush(position: Vector2(tileSize * 27, tileSize * 33.5), type: BushType.bush2),
          ...bush(position: Vector2(tileSize * 18.75, tileSize * 32.5), type: BushType.bush1),
          ...bush(position: Vector2(tileSize * 20, tileSize * 8.25), type: BushType.bush1),
          ...bush(position: Vector2(tileSize * 57, tileSize * 27), type: BushType.bush1),
          ...bush(position: Vector2(tileSize * 37.5, tileSize * 33.5), type: BushType.bush2),
          ...bush(position: Vector2(tileSize * 40, tileSize * 29.25), type: BushType.bush1),
          ...bush(position: Vector2(tileSize * 55, tileSize * 4), type: BushType.bush2),
          ...bush(position: Vector2(tileSize * 60.5, tileSize * -1.5), type: BushType.bush2),
          ...bush(position: Vector2(tileSize * 50.5, tileSize * 12), type: BushType.bush1),
          ...bush(position: Vector2(tileSize * 53.25, tileSize * 13), type: BushType.bush2),
          ...bush(position: Vector2(tileSize * 56.75, tileSize * 20), type: BushType.bush1),
          ...bush(position: Vector2(tileSize * 58.5, tileSize * 16), type: BushType.bush2),
          ...bush(position: Vector2(tileSize * 50, tileSize * 38.5), type: BushType.bush1),
          ...bush(position: Vector2(tileSize * 49.25, tileSize * 38.75), type: BushType.bush1),
          ...bush(position: Vector2(tileSize * 5.5, tileSize * 24.5), type: BushType.bush2),
          ...bush(position: Vector2(tileSize * 9, tileSize * 22), type: BushType.bush1),
          // Tree(position: Vector2(0, 0)),
          //Yellow house
          ExitMat(position: Vector2(tileSize * 49, tileSize * 40), exitFunction: () {
            // Yellow house:
            goTo(destination: SmallYellowHouse(
              gameController: widget.gameController,
              playerOneController: widget.playerOneController,
              initPosition: Vector2(tileSize * 6, tileSize * 14.5),
              initDirection: Direction.up,
            ));
          }),
          ExitMat(position: Vector2(tileSize * 33.5, tileSize * 18), exitFunction: () {
            // Church:
            goTo(destination: Church(
              gameController: widget.gameController,
              playerOneController: widget.playerOneController,
              initPosition: Vector2(tileSize * 9.5, tileSize * 16),
              initDirection: Direction.up,
            ));
          }),
          ExitMat(position: Vector2(tileSize * 39.5, tileSize * 19), exitFunction: () {
            // Town Hall:
            goTo(destination: GardenMap(
              gameController: widget.gameController,
              playerOneController: widget.playerOneController,
              initPosition: Vector2(tileSize * 15, tileSize * 28),
              initDirection: Direction.up,
            ));
          }),
          ExitMat(position: Vector2(tileSize * 6.75, tileSize * 18), exitFunction: () {
            // Carpenter:
            goTo(destination: GardenMap(
              gameController: widget.gameController,
              playerOneController: widget.playerOneController,
              initPosition: Vector2(tileSize * 15, tileSize * 28),
              initDirection: Direction.up,
            ));
          }),
          ExitMat(position: Vector2(tileSize * 8, tileSize * 36), exitFunction: () {
            // School:
            goTo(destination: GardenMap(
              gameController: widget.gameController,
              playerOneController: widget.playerOneController,
              initPosition: Vector2(tileSize * 15, tileSize * 28),
              initDirection: Direction.up,
            ));
          }),
          ExitMat(position: Vector2(tileSize * 46, tileSize * 27), exitFunction: () {
            // Blacksmith:
            goTo(destination: BlacksmithHouse(
              gameController: widget.gameController,
              playerOneController: widget.playerOneController,
              // initPosition: Vector2(tileSize * 15, tileSize * 28),
              initPosition: Vector2(tileSize * 5, tileSize * 15.5),
              initDirection: Direction.up,
            ));
          }),
          ExitMat(position: Vector2(tileSize * 24.5, tileSize * 32.5), exitFunction: () {
            // Taylor:
            goTo(destination: GardenMap(
              gameController: widget.gameController,
              playerOneController: widget.playerOneController,
              initPosition: Vector2(tileSize * 15, tileSize * 28),
              initDirection: Direction.up,
            ));
          }),
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
