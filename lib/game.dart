import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:projeto_gbb_demo/game/items/armor.dart';
import 'package:projeto_gbb_demo/maps/griffin/griffin_base.dart';
import 'package:projeto_gbb_demo/maps/main_village/main_village.dart';
import 'package:projeto_gbb_demo/maps/tavern/tavern.dart';
import 'package:projeto_gbb_demo/maps/town.dart';
import 'package:projeto_gbb_demo/players/controller/player_controller.dart';
import 'package:provider/provider.dart';
import 'game/enum/character_class.dart';
import 'game/enum/character_faction.dart';
import 'game/controller/game_controller.dart';

double tileSize = 192;
const CharacterClass playerOneClass = CharacterClass.SwordsMan;
// const CharacterFaction playerTwoFaction = CharacterFaction.Capitalist;
// SimpleDirectionAnimation playerTwoAnimations = getArcherAnimations(playerTwoFaction);

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  // late final GameController gameController;
  late final CharacterFaction playerFaction;
  late final SimpleDirectionAnimation playerOneAnimations;
  late final String id;

  @override
  void initState() {
    context.read<LocalGameController>().startDaynightCycle();
    context.read<PlayerOneController>().changeEquipment(yetiArmor);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    LocalGameController gameController = context.read<LocalGameController>();
    PlayerOneController playerOneController = context.read<PlayerOneController>();

    // return TownMap(gameController: gameController, playerOneController: playerOneController);
    // return TavernMap(
    //   gameController: gameController,
    //   playerOneController: playerOneController,
    //   initPosition: Vector2(tileSize * 6.5, tileSize * 12),
    //   initDirection: Direction.up,
    // );
    return MainVillageMap(
      gameController: gameController,
      playerOneController: playerOneController,
      initPosition: Vector2(tileSize * 6.5, tileSize * 12),
      initDirection: Direction.up,
    );
    // return GriffinBase(
    //   gameController: gameController,
    //   playerOneController: playerOneController,
    // );
  }
}
