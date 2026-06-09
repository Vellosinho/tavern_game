import 'package:bonfire/bonfire.dart';
import 'package:bonfire/player/lit_player.dart';
import 'package:flutter/material.dart';
import 'package:projeto_gbb_demo/common/common.dart';
import 'package:projeto_gbb_demo/game.dart';
import 'package:projeto_gbb_demo/game/interface/player_interface.dart';
import 'package:projeto_gbb_demo/game/items/armor.dart';
import 'package:projeto_gbb_demo/game/objects/daytime_clock.dart';
import 'package:projeto_gbb_demo/maps/griffin/griffin.dart';
import 'package:projeto_gbb_demo/maps/griffin/objects/pillar.dart';
import 'package:projeto_gbb_demo/players/controller/player_controller.dart';
import 'package:projeto_gbb_demo/players/player_one/base_player.dart';
import 'package:provider/provider.dart';

class GriffinBase extends StatefulWidget {
  final LocalGameController gameController;
  final PlayerOneController playerOneController;
  const GriffinBase(
      {super.key,
      required this.gameController,
      required this.playerOneController,
      });

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
    widget.playerOneController.changeEquipment(yetiArmor);
    playerFaction = context.read<PlayerConsts>().faccao;
    playerOneAnimations = getAnimations(playerOneClass, playerFaction);
    widget.gameController.enableVisibility();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double tileSize = 192;

    LitPlayer player = BasePlayer(
      playerController: widget.playerOneController,
      localGameController: widget.gameController,
      playerLife: widget.playerOneController.playerLife.toDouble(),
      initDirection: Direction.up,
      onHit: () {
        widget.playerOneController.hit(2);
      },
      position: Vector2(tileSize * 15.5, tileSize * 18),
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
          position: Vector2(tileSize * 14, tileSize * 10), localGameController: widget.gameController, id: 'grifo',
        ),
        Pillar(position: Vector2(tileSize * 10, tileSize * 18), pillarNumber: 1),
        Pillar(position: Vector2(tileSize * 20, tileSize * 18), pillarNumber: 2),
        Pillar(position: Vector2(tileSize * 7, tileSize * 11), pillarNumber: 3),
        Pillar(position: Vector2(tileSize * 23, tileSize * 11), pillarNumber: 4),
        Pillar(position: Vector2(tileSize * 9, tileSize * 5), pillarNumber: 5),
        Pillar(position: Vector2(tileSize * 21, tileSize * 4), pillarNumber: 6),
        Pillar(position: Vector2(tileSize * 15, tileSize * 1), pillarNumber: 7),
        DayTimeClock(
          onStartRaining: () {},
          position: Vector2(0,0), localGameController: widget.gameController),
      ],
      cameraConfig: CameraConfig(zoom: 0.8, moveOnlyMapArea: true),
      player: player,
      overlayBuilderMap: {
        PlayerInterface.overlayKey: (context, game) =>
            PlayerInterface(game: game),
      },
      initialActiveOverlays: const [
        PlayerInterface.overlayKey,
      ],
      // showCollisionArea: true,
    );
  }
}
