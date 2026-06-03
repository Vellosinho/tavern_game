import 'package:bonfire/bonfire.dart';
import 'package:bonfire/player/lit_player.dart';
import 'package:flutter/material.dart';
import 'package:projeto_gbb_demo/common/common.dart';
import 'package:projeto_gbb_demo/game.dart';
import 'package:projeto_gbb_demo/game/interface/player_interface.dart';
import 'package:projeto_gbb_demo/game/objects/ingredients/main_dish.dart';
import 'package:projeto_gbb_demo/game/objects/kitchen/cutting_board.dart';
import 'package:projeto_gbb_demo/game/objects/kitchen/mixing_bowl.dart';
import 'package:projeto_gbb_demo/game/objects/kitchen/pan.dart';
import 'package:projeto_gbb_demo/game/objects/kitchen/stove.dart';
import 'package:projeto_gbb_demo/game/structs/change_map_transition.dart';
import 'package:projeto_gbb_demo/maps/tavern/tavern.dart';
import 'package:projeto_gbb_demo/players/controller/player_controller.dart';
import 'package:projeto_gbb_demo/players/player_one/base_player.dart';
import 'package:uuid/uuid.dart';

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
  late final CharacterFaction playerFaction;
  late final SimpleDirectionAnimation playerOneAnimations;
  late final String id;

  @override
  void initState() {
    // widget.gameController.disableVisibility();
    id = const Uuid().v1();
    widget.gameController.enableVisibility();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double tileSize = 192;

    LitPlayer player = BasePlayer(
      localGameController: widget.gameController,
      playerController: widget.playerOneController,
      id: id,
      playerLife: widget.playerOneController.playerLife.toDouble(),
      initDirection: Direction.right,
      onHit: () {
        widget.playerOneController.hit(2);
      },
      position: Vector2(tileSize * 1, tileSize * 5),
    );

    void exitToTown() {
      widget.gameController.disableVisibility(isBrightEnvironment: true);
      Future.delayed(Duration(milliseconds: 1000), () {
      player.position = Vector2(tileSize * 20, tileSize * 15);
      widget.playerOneController.toggleResetCollision();
      Future.delayed(Duration(milliseconds: 150), () {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => TavernMap(
              gameController: widget.gameController,
              playerOneController: widget.playerOneController,
              initPosition: Vector2(tileSize * 13.5, tileSize * 9),
              initDirection: Direction.left,
            ),
            transitionDuration: Duration(milliseconds: 1),
            reverseTransitionDuration: Duration(milliseconds: 1),
          ),
        );
      });});
    }

    widget.playerOneController.setImportantCoords(
      newCoords: [
        ChangeMapTransition(coords: Vector2(-200, 972), orientation: TransitionOrientation.vertical)
      ], 
      newFunctions: [
        () => exitToTown(),
      ]
    );

    return BonfireWidget(
      backgroundColor: Color(0xff000000),
      playerControllers: [
        Keyboard(
            config: KeyboardConfig(acceptedKeys: [
          LogicalKeyboardKey.arrowDown,
          LogicalKeyboardKey.arrowLeft,
          LogicalKeyboardKey.arrowUp,
          LogicalKeyboardKey.arrowRight,
          LogicalKeyboardKey.keyZ,
          LogicalKeyboardKey.keyX,
          LogicalKeyboardKey.keyC,
          LogicalKeyboardKey.escape,
        ]))
      ],
      map: WorldMapByTiled(
        WorldMapReader.fromAsset(
            'map/house_interior/yellow_house/kitchen_map.json'),
        forceTileSize: Vector2(tileSize, tileSize),
      ),
      // lightingColorGame: Colors.orange[400]!.withAlpha(48),
      components: [
        Stove(playerOneController: widget.playerOneController, position: Vector2(tileSize * 5, tileSize * 0.6)),
        Pan(playerOneController: widget.playerOneController, position: Vector2(tileSize * 5.8, tileSize * 0.85)),
        MixingBowl(playerOneController: widget.playerOneController, position: Vector2(tileSize * 2, tileSize * 2.5)),
        CuttingBoard(playerOneController: widget.playerOneController, position: Vector2(tileSize * 8.5, tileSize * 1.1)),
        MainDish(playerOneController: widget.playerOneController, position: Vector2(tileSize * 5.25, tileSize * 5.5)),
        // Chest(playerOneController: widget.playerOneController, position: Vector2(tileSize * 3, tileSize * 7.5)),
      ],
      cameraConfig: CameraConfig(zoom: 0.8, moveOnlyMapArea: true),
      player: player,
      overlayBuilderMap: {
        PlayerInterface.overlayKey: (context, game) =>
            PlayerInterface(game: game, characterClass: playerOneClass),
      },
      initialActiveOverlays: const [
        PlayerInterface.overlayKey,
      ],
      // showCollisionArea: true,
    );
  }
}
