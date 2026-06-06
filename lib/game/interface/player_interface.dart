import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:projeto_gbb_demo/game/enum/weather.dart';
import 'package:projeto_gbb_demo/game/interface/minimap.dart';
import 'package:projeto_gbb_demo/game/items/base_item.dart';
import 'package:projeto_gbb_demo/players/controller/player_controller.dart';
import '../enum/character_faction.dart';
import '../controller/game_controller.dart';
import '../game_sprite_sheet.dart';
import 'package:provider/provider.dart';
import '../enum/character_class.dart';

class PlayerInterface extends StatefulWidget {
  final BonfireGame game;
  final bool? isOutside;
  static const overlayKey = 'playerInterface';

  PlayerInterface({
    required this.game,
    this.isOutside,
    super.key});

  @override
  State<PlayerInterface> createState() => _PlayerInterfaceState();
}

class _PlayerInterfaceState extends State<PlayerInterface> {
  @override
  Widget build(BuildContext context) {
    // return PlayerLife(game: widget.game, characterClass: widget.characterClass, characterFaction: widget.characterFaction,);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Consumer2<LocalGameController, PlayerOneController>(
        builder: (context, controller, playerOneController, _) => Stack(
          children: [
            if (widget.isOutside ?? false)
              ViewWeather(controller),
            PlayerLife(
              controller: controller,
              playerOneController: playerOneController,
              game: widget.game,),
            GameMiniMap(game: widget.game),
            AnimatedContainer(
              duration: Duration(milliseconds: 600),
              color: controller.visibilityScreen,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
            )
          ],
        ),
      ),
    );
  }
}

class ViewWeather extends StatelessWidget {
  final LocalGameController controller;
  const ViewWeather(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ViewRain(weather: controller.currentWeather),
      ],
    );
  }
}

class ViewRain extends StatelessWidget {
  final Weather weather;
  const ViewRain({required this.weather, super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: (weather == Weather.rain) ? 1 : 0,
      duration: Duration(seconds: 2),
      child: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: FittedBox(
              fit: BoxFit.fill,
              child: Image.asset(
                "assets/images/effects/rain_large.gif",
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: DecoratedBox(decoration: BoxDecoration(color: Color(0xff000061).withAlpha(120))),
          ),
        ]
      ),
    );
  }
}

class PlayerLife extends StatelessWidget {
  final LocalGameController controller;
  final PlayerOneController playerOneController;
  final BonfireGame game;

  const PlayerLife({
      required this.controller,
      required this.playerOneController,
      required this.game,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[900]!.withAlpha(0),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 64),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // LifebarInterface(characterClass: characterClass, characterFaction: characterFaction),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Inventory(controller: controller, playerOneController: playerOneController,),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Inventory extends StatelessWidget {
  final LocalGameController controller;
  final PlayerOneController playerOneController;
  const Inventory({required this.controller, required this.playerOneController, super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
        SizedBox(
            height: 88,
            width: 304,
            child: DecoratedBox(
              decoration: BoxDecoration(color: Colors.black.withAlpha(160)),
            )),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              InventorySlot(
                item: playerOneController.inventory[0],
              ),
              InventorySlot(
                item: playerOneController.inventory[1],
              ),
              InventorySlot(
                item: playerOneController.inventory[2],
              ),
              InventorySlot(
                item: playerOneController.inventory[3],
              ),
            ],
          ),
        ),
        InterfaceSpriteSheet.inventoryBar
      ]
    );
  }
}

class InventorySlot extends StatelessWidget {
  final Item? item;
  const InventorySlot({this.item, super.key});

  @override
  Widget build(BuildContext context) {
    // return const Placeholder();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      child: SizedBox(
          height: 64,
          width: 64,
          child: (item?.assetPath == 'empty') ? SizedBox() : item?.assetPath),
    );
  }
}

class LifebarInterface extends StatelessWidget {
  final CharacterClass characterClass;
  final CharacterFaction? characterFaction;
  const LifebarInterface(
      {required this.characterClass,
      required this.characterFaction,
      super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> token = getToken(characterClass, characterFaction!);
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 144, top: 96),
          child: Row(
            children: [
              InterfaceSpriteSheet.coin,
              const SizedBox(width: 8),
              Text(
                '${context.watch<PlayerOneController>().playerWallet}',
                style: TextStyle(
                    fontFamily: 'PressStart2P',
                    color: Colors.amber[400],
                    fontSize: 24),
              ),
              const SizedBox(width: 8),
              InterfaceSpriteSheet.people,
              const SizedBox(width: 8),
              Text(
                '${context.watch<PlayerOneController>().playerFollowers}',
                style: const TextStyle(
                    fontFamily: 'PressStart2P',
                    color: Colors.white,
                    fontSize: 24),
              ),
            ],
          ),
        ),
        token[1],
        token[0],
        LifeBar(life: (20 - context.watch<PlayerOneController>().playerLife)),
      ],
    );
  }
}

class LifeBar extends StatefulWidget {
  final num life;
  const LifeBar({required this.life, super.key});

  @override
  State<LifeBar> createState() => _LifeBarState();
}

class _LifeBarState extends State<LifeBar> {
  @override
  Widget build(BuildContext context) {
    // return Stack(
    //   children: [
    //     InterfaceSpriteSheet.lifebarList[19],
    //     InterfaceSpriteSheet.lifebarList[widget.life.toInt()],
    //   ],
    // );
    return InterfaceSpriteSheet.lifeBar;
  }
}
