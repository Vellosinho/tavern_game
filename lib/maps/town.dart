import 'package:bonfire/bonfire.dart';
import 'package:bonfire/player/lit_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projeto_gbb_demo/game.dart';
import 'package:projeto_gbb_demo/game/controller/game_controller.dart';
import 'package:projeto_gbb_demo/game/enum/character_faction.dart';
import 'package:projeto_gbb_demo/game/enum/enum_day_time.dart';
import 'package:projeto_gbb_demo/game/game_sprite_sheet.dart';
import 'package:projeto_gbb_demo/game/interface/player_interface.dart';
import 'package:projeto_gbb_demo/game/objects/daytime_clock.dart';
import 'package:projeto_gbb_demo/maps/tavern/components/exit_mat.dart';
import 'package:projeto_gbb_demo/maps/tavern/tavern.dart';
import 'package:projeto_gbb_demo/parallax/parallax_clouds.dart';
import 'package:projeto_gbb_demo/players/controller/player_controller.dart';
import 'package:projeto_gbb_demo/players/player_consts.dart';
import 'package:projeto_gbb_demo/players/player_one/base_player.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class TownMap extends StatefulWidget {
  final LocalGameController gameController;
  final PlayerOneController playerOneController;

  const TownMap({super.key, required this.gameController, required this.playerOneController});

  @override
  State<TownMap> createState() => _TownMapState();
}

class _TownMapState extends State<TownMap> {
  late final CharacterFaction playerFaction;
  late final SimpleDirectionAnimation playerOneAnimations;
  late final String id;
  late Color initialLighting;

  @override
  void initState() {
    getLighting();
    playerFaction = context.read<PlayerConsts>().faccao;
    playerOneAnimations = getAnimations(playerOneClass, playerFaction);
    id = const Uuid().v1();
    widget.gameController.enableVisibility();
    super.initState();
  }

  void getLighting() {
      switch (widget.gameController.daytime) {
        case DayTime.sunrise:
          initialLighting = Colors.orange[400]!.withAlpha(48);
          return;
        case DayTime.noon:
          initialLighting = Colors.orange[400]!.withAlpha(0);
          return;
        case DayTime.sunset:
          initialLighting = Colors.orange[400]!.withAlpha(48);
          return;
        case DayTime.night:
          initialLighting = Colors.indigo[900]!.withAlpha(148);
          return;
        default:
          initialLighting = Colors.orange[400]!.withAlpha(48);
          return;
      }
    }
  
  @override
  Widget build(BuildContext context) {
    
    double tileSize = 192;
    LitPlayer player = BasePlayer(
      playerController: widget.playerOneController,
      id: id,
      playerLife: widget.playerOneController.playerLife.toDouble(),
      onHit: () {
        widget.playerOneController.hit(2);
      },
      position: Vector2(tileSize * 19, tileSize * 13),
    );
    
    void enterTavern() {
      widget.gameController.disableVisibility();
      Future.delayed(Duration(milliseconds: 3000), () {

      player.position = Vector2(tileSize * 20, tileSize * 15);
      widget.gameController.toggleResetCollision();
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => TavernMap(
            gameController: widget.gameController,
            playerOneController: widget.playerOneController,
          ),
          transitionDuration: Duration(milliseconds: 1),
          reverseTransitionDuration: Duration(milliseconds: 1),
        ),
      );
      });
    }

    return BonfireWidget(
      backgroundColor: Color(0xff2c6ec7),
      background: BonfireParallaxBackground(),
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
      // widget.gameController: widget.gameController,
      lightingColorGame: initialLighting,
      components: [
        // BlackSmithMaster(
        //     position: Vector2(tileSize * 19.25, tileSize * 15.5),
        //     size: PlayerConsts.tallNPCSize,
        //     hitboxSize: PlayerConsts.characterHitbox,
        //     hitboxPosition: PlayerConsts.hitboxPosition,
        //     controller: widget.gameController),
        // Anvil(
        //     position: Vector2(tileSize * 21.5, tileSize * 19.5),
        //     localGameController: widget.gameController),
        // Furnace(
        //     position: Vector2(tileSize * 21, tileSize * 11),
        //     localGameController: widget.gameController),
        // SwordShippingBox(
        //     position: Vector2(tileSize * 19, tileSize * 18.5),
        //     localGameController: widget.gameController),
        // LaunchStation(
        //     position: Vector2(tileSize * 14, tileSize * 13.5),
        //     localGameController: widget.gameController),
        // SmithingTable(
        //     position: Vector2(tileSize * 22.75, tileSize * 16.85),
        //     localGameController: widget.gameController),
        DayTimeClock(position: Vector2(0,0), localGameController: widget.gameController),
        ExitMat(position: Vector2(tileSize * 19, tileSize * 13), exitFunction: () {
          enterTavern();
        })
      ],
      // ],
      cameraConfig: CameraConfig(zoom: 0.75, moveOnlyMapArea: true),
      map: WorldMapByTiled(
          WorldMapReader.fromAsset('ruins_village_map/ruins_map_pvp.json'),
          forceTileSize: Vector2(tileSize, tileSize)),
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
 