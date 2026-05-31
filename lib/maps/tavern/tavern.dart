import 'package:bonfire/bonfire.dart';
import 'package:bonfire/player/lit_player.dart';
import 'package:flutter/material.dart';
import 'package:projeto_gbb_demo/common/common.dart';
import 'package:projeto_gbb_demo/game.dart';
import 'package:projeto_gbb_demo/game/interface/player_interface.dart';
import 'package:projeto_gbb_demo/game/objects/chest.dart';
import 'package:projeto_gbb_demo/maps/town.dart';
import 'package:projeto_gbb_demo/players/controller/player_controller.dart';
import 'package:projeto_gbb_demo/players/player_one/base_player.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class TavernMap extends StatefulWidget {
  final LocalGameController gameController;
  final PlayerOneController playerOneController;
  const TavernMap(
      {super.key,
      required this.gameController,
      required this.playerOneController});

  @override
  State<TavernMap> createState() => _TavernMapState();
}

class _TavernMapState extends State<TavernMap> {
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
      playerController: widget.playerOneController,
      id: id,
      playerLife: widget.playerOneController.playerLife.toDouble(),
      initDirection: Direction.up,
      onHit: () {
        widget.playerOneController.hit(2);
      },
      position: Vector2(tileSize * 6.5, tileSize * 13),
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
            pageBuilder: (context, animation1, animation2) => TownMap(
              gameController: widget.gameController,
              playerOneController: widget.playerOneController,
            ),
            transitionDuration: Duration(milliseconds: 1),
            reverseTransitionDuration: Duration(milliseconds: 1),
          ),
        );
      });});
    }

    widget.playerOneController.setImportantCoords(
      newCoords: [
        Vector2(1268,2739)
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
            'map/house_interior/yellow_house/tavern_map.json'),
        forceTileSize: Vector2(tileSize, tileSize),
      ),
      // lightingColorGame: Colors.orange[400]!.withAlpha(48),
      components: [
        Chest(playerOneController: widget.playerOneController, position: Vector2(tileSize * 3, tileSize * 7.5)),
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
    );
  }
}
