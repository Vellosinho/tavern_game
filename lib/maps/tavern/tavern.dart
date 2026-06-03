import 'package:bonfire/bonfire.dart';
import 'package:bonfire/player/lit_player.dart';
import 'package:flutter/material.dart';
import 'package:projeto_gbb_demo/common/common.dart';
import 'package:projeto_gbb_demo/game.dart';
import 'package:projeto_gbb_demo/game/interface/player_interface.dart';
import 'package:projeto_gbb_demo/game/objects/chest.dart';
import 'package:projeto_gbb_demo/game/structs/change_map_transition.dart';
import 'package:projeto_gbb_demo/maps/tavern/kitchen.dart';
import 'package:projeto_gbb_demo/maps/town.dart';
import 'package:projeto_gbb_demo/players/controller/player_controller.dart';
import 'package:projeto_gbb_demo/players/player_one/base_player.dart';
import 'package:uuid/uuid.dart';

class TavernMap extends StatefulWidget {
  final LocalGameController gameController;
  final PlayerOneController playerOneController;
  final Vector2? initPosition;
  final Direction? initDirection;
  const TavernMap(
    {
      super.key,
      required this.gameController,
      required this.playerOneController,
      this.initPosition,
      this.initDirection,
    });

  @override
  State<TavernMap> createState() => _TavernMapState();
}

class _TavernMapState extends State<TavernMap> {
  late final CharacterFaction playerFaction;
  late final SimpleDirectionAnimation playerOneAnimations;
  late final String id;

  @override
  void initState() {
    id = const Uuid().v1();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_){
      widget.gameController.setEnvironmentTemperature(environmentTemperature: 24, modifier: 1.0);
      widget.gameController.enableVisibility();
    });
    double tileSize = 192;

    LitPlayer player = BasePlayer(
      localGameController: widget.gameController,
      playerController: widget.playerOneController,
      id: id,
      playerLife: widget.playerOneController.playerLife.toDouble(),
      initDirection: widget.initDirection ?? Direction.up,
      onHit: () {
        widget.playerOneController.hit(2);
      },
      position: widget.initPosition ?? Vector2(tileSize * 6.5, tileSize * 13),
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
    void enterKitchen() {
      widget.gameController.disableVisibility(isBrightEnvironment: true);
      Future.delayed(Duration(milliseconds: 1000), () {
      player.position = Vector2(tileSize * 20, tileSize * 15);
      widget.playerOneController.toggleResetCollision();
      Future.delayed(Duration(milliseconds: 150), () {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => KitchenMap(
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
        ChangeMapTransition(coords: Vector2(1268,2739), orientation: TransitionOrientation.horizontal),
        ChangeMapTransition(coords: Vector2(3013,1900), orientation: TransitionOrientation.vertical),
      ], 
      newFunctions: [
        () => exitToTown(),
        () => enterKitchen(),
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
