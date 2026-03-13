import 'package:bonfire/bonfire.dart';
import 'package:bonfire/player/lit_player.dart';
import 'package:flutter/material.dart';
import 'package:projeto_gbb_demo/common/common.dart';
import 'package:projeto_gbb_demo/forge_minigame/minigame.dart';
import 'package:projeto_gbb_demo/game.dart';
import 'package:projeto_gbb_demo/game/interface/player_interface.dart';
import 'package:projeto_gbb_demo/game/objects/chest.dart';
import 'package:projeto_gbb_demo/maps/griffin/griffin.dart';
import 'package:projeto_gbb_demo/players/player_one/blacksmith/blacksmith.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class GriffinBase extends StatefulWidget {
  final LocalGameController controller;
  const GriffinBase(
      {super.key,
      required this.controller});

  @override
  State<GriffinBase> createState() => _GriffinBaseState();
}

class _GriffinBaseState extends State<GriffinBase> {
  late final CharacterFaction playerFaction;
  late final SimpleDirectionAnimation playerOneAnimations;
  late final String id;

  @override
  void initState() {
    // widget.controller.disableVisibility();
    widget.controller.changeEquipment("griffin");
    playerFaction = context.read<PlayerConsts>().faccao;
    playerOneAnimations = getAnimations(playerOneClass, playerFaction);
    id = const Uuid().v1();
    widget.controller.enableVisibility();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double tileSize = 192;

    LitPlayer player = BlacksmithClass(
      localGameController: widget.controller,
      id: id,
      playerLife: context.watch<LocalGameController>().playerLife.toDouble(),
      initDirection: Direction.up,
      onHit: () {
        widget.controller.hit(2);
      },
      faction: playerFaction,
      position: Vector2(tileSize * 20, tileSize * 16),
    );

    // void exitToTown() {
    //   widget.controller.disableVisibility(isBrightEnvironment: true);
    //   Future.delayed(Duration(milliseconds: 1000), () {
    //   player.position = Vector2(tileSize * 20, tileSize * 15);
    //   widget.controller.toggleResetCollision();
    //   Future.delayed(Duration(milliseconds: 150), () {
    //     Navigator.pushReplacement(
    //       context,
    //       PageRouteBuilder(
    //         pageBuilder: (context, animation1, animation2) => TownMap(
    //           controller: widget.controller,
    //         ),
    //         transitionDuration: Duration(milliseconds: 1),
    //         reverseTransitionDuration: Duration(milliseconds: 1),
    //       ),
    //     );
    //   });});
    // }

    // widget.controller.setImportantCoords(
    //   newCoords: [
    //     Vector2(1268,2739)
    //   ], 
    //   newFunctions: [
    //     () => exitToTown(),
    //   ]
    // );

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
            'map/griffin_base/griffin_base.json'),
        forceTileSize: Vector2(tileSize, tileSize),
      ),
      components: [
        Griffin(
          position: Vector2(tileSize * 18, tileSize * 10), localGameController: widget.controller, id: 'grifo',
        )
      ],
      cameraConfig: CameraConfig(zoom: 0.8, moveOnlyMapArea: true),
      player: player,
      overlayBuilderMap: {
        PlayerInterface.overlayKey: (context, game) =>
            PlayerInterface(game: game, characterClass: playerOneClass),
        MiniGame.overlayKey: (context, game) => MiniGame(),
      },
      initialActiveOverlays: const [
        PlayerInterface.overlayKey,
        MiniGame.overlayKey,
      ],
      // showCollisionArea: true,
    );
  }
}
