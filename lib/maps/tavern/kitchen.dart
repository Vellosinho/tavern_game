// import 'package:bonfire/bonfire.dart';
// import 'package:bonfire/player/lit_player.dart';
// import 'package:flutter/material.dart';
// import 'package:projeto_gbb_demo/common/common.dart';
// import 'package:projeto_gbb_demo/game.dart';
// import 'package:projeto_gbb_demo/game/interface/player_interface.dart';
// import 'package:projeto_gbb_demo/game/objects/ingredients/main_dish.dart';
// import 'package:projeto_gbb_demo/game/objects/kitchen/cutting_board.dart';
// import 'package:projeto_gbb_demo/game/objects/kitchen/mixing_bowl.dart';
// import 'package:projeto_gbb_demo/game/objects/kitchen/pan.dart';
// import 'package:projeto_gbb_demo/game/objects/kitchen/stove.dart';
// import 'package:projeto_gbb_demo/game/structs/change_map_transition.dart';
// import 'package:projeto_gbb_demo/maps/tavern/tavern.dart';
// import 'package:projeto_gbb_demo/players/controller/player_controller.dart';
// import 'package:projeto_gbb_demo/players/player_one/base_player.dart';
// import 'package:uuid/uuid.dart';

import 'package:bonfire/bonfire.dart';
import 'package:bonfire/map/tiled/world_map_by_tiled.dart';
import 'package:bonfire/map/util/world_map_reader.dart';
import 'package:flutter/material.dart';
import 'package:projeto_gbb_demo/base_map.dart';
import 'package:projeto_gbb_demo/game.dart';
import 'package:projeto_gbb_demo/game/controller/game_controller.dart';
import 'package:projeto_gbb_demo/game/objects/ingredients/main_dish.dart';
import 'package:projeto_gbb_demo/game/objects/kitchen/cutting_board.dart';
import 'package:projeto_gbb_demo/game/objects/kitchen/mixing_bowl.dart';
import 'package:projeto_gbb_demo/game/objects/kitchen/pan.dart';
import 'package:projeto_gbb_demo/game/objects/kitchen/stove.dart';
import 'package:projeto_gbb_demo/game/structs/change_map_transition.dart';
import 'package:projeto_gbb_demo/maps/tavern/tavern.dart';
import 'package:projeto_gbb_demo/players/controller/player_controller.dart';

class KitchenMap extends StatefulWidget {
  final LocalGameController gameController;
  final PlayerOneController playerOneController;
  const KitchenMap(
      {super.key,
      required this.gameController,
      required this.playerOneController});

  @override
  State<KitchenMap> createState() => _KitchenMapState();
}

class _KitchenMapState extends State<KitchenMap> {

  @override
  Widget build(BuildContext context) {
    return BaseMap(
      gameController: widget.gameController,
        playerOneController: widget.playerOneController, 
        map: WorldMapByTiled(
          WorldMapReader.fromAsset(
            'map/house_interior/yellow_house/kitchen_map.json'),
          forceTileSize: Vector2(tileSize, tileSize),
        ),
        components: [
          Stove(playerOneController: widget.playerOneController, position: Vector2(tileSize * 5, tileSize * 0.6)),
          Pan(playerOneController: widget.playerOneController, position: Vector2(tileSize * 5.8, tileSize * 0.85)),
          MixingBowl(playerOneController: widget.playerOneController, position: Vector2(tileSize * 2, tileSize * 2.5)),
          CuttingBoard(playerOneController: widget.playerOneController, position: Vector2(tileSize * 8.5, tileSize * 1.1)),
          MainDish(playerOneController: widget.playerOneController, position: Vector2(tileSize * 5.25, tileSize * 5.5)),
        ],
        initLocation: Vector2(tileSize * 1, tileSize * 5),
        initDirection: Direction.right,
        locationActions: [
          LocationAction(
            coords: Vector2(-200, 972),
            orientation: TransitionOrientation.vertical,
            destination: TavernMap(
              gameController: widget.gameController, playerOneController: widget.playerOneController,
              initPosition: Vector2(tileSize * 13.5, tileSize * 9), initDirection: Direction.left,
            ),
          ),
        ],
    );
  }
}