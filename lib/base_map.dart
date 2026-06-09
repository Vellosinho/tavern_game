import 'package:bonfire/bonfire.dart';
import 'package:bonfire/player/lit_player.dart';
import 'package:flutter/material.dart';
import 'package:projeto_gbb_demo/common/common.dart';
import 'package:projeto_gbb_demo/game/enum/enum_day_time.dart';
import 'package:projeto_gbb_demo/game/interface/player_interface.dart';
import 'package:projeto_gbb_demo/game/objects/daytime_clock.dart';
import 'package:projeto_gbb_demo/game/objects/weather_objects/map_climate.dart';
import 'package:projeto_gbb_demo/game/structs/change_map_transition.dart';
import 'package:projeto_gbb_demo/players/controller/player_controller.dart';
import 'package:projeto_gbb_demo/players/player_one/base_player.dart';

class BaseMap extends StatefulWidget {
  final LocalGameController gameController;
  final PlayerOneController playerOneController;
  final GameMap map;
  final List<GameComponent> components;
  final Vector2 initLocation;
  final Direction initDirection;
  final bool? hasDayLightCycle;
  final Color? backgroundColor;
  final List<LocationAction>? locationActions;
  final GameBackground? background;
  final MapClimate? climate;


  const BaseMap(
      {super.key,
      required this.gameController,
      required this.playerOneController,
      required this.map,
      required this.components,
      required this.initLocation,
      required this.initDirection,
      this.hasDayLightCycle,
      this.backgroundColor,
      this.locationActions,
      this.background,
      this.climate,
      });

  @override
  State<BaseMap> createState() => _BaseMapState();
}

class _BaseMapState extends State<BaseMap> {
  late final CharacterFaction playerFaction;
  late final SimpleDirectionAnimation playerOneAnimations;
  final List<Function> listActions = [];
  late Color initialLighting; 

  @override
  void initState() {
    checkHasDaylight();
    widget.gameController.enableVisibility();
    populateFunctionList();
    super.initState();
  }

  void checkHasDaylight() {
    // if (widget.hasDayLightCycle ?? false) {
    //   widget.components.add(DayTimeClock(
    //     position: Vector2(0,0),
    //     localGameController: widget.gameController,
    //   ));
    // }
  }

  @override
  void didChangeDependencies() {
    if (widget.hasDayLightCycle ?? false) {
      getLighting();
    }
    super.didChangeDependencies();
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

  void populateFunctionList() {
    for (int i = 0; i < (widget.locationActions?.length ?? 0); i++) {
      if (widget.locationActions?[i].destination != null) {
        listActions.add(() {
          goTo(widget.locationActions![i].destination!);
        });
      } else if (widget.locationActions?[i].action != null) {
        listActions.add(widget.locationActions![i].action!);
      } else {
        widget.locationActions!.removeWhere((item) => item.coords == widget.locationActions![i].coords);
      }
    }
  }

  void goTo(StatefulWidget destination) {
      widget.gameController.disableVisibility(isBrightEnvironment: true);
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

  @override
  Widget build(BuildContext context) {
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.gameController.setEnvironmentTemperature(environmentTemperature: widget.climate?.baseTemperature ?? 24, modifier: widget.climate?.baseTemperature ?? 1.0, isOutside: false);
      widget.gameController.enableVisibility();
      if (widget.hasDayLightCycle ?? false) {
        getLighting();
      }
    });

    LitPlayer player = BasePlayer(
      localGameController: widget.gameController,
      playerController: widget.playerOneController,
      playerLife: widget.playerOneController.playerLife.toDouble(),
      initDirection: widget.initDirection,
      onHit: () {
        widget.playerOneController.hit(2);
      },
      position: widget.initLocation,
    );

    widget.playerOneController.setImportantCoords(
      newCoords: widget.locationActions ?? [],
      newFunctions: listActions,
    );

    return BonfireWidget(
      backgroundColor: widget.backgroundColor ?? Color(0xff000000),
      background: widget.background,
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
      map: widget.map,
      components: widget.components,
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
