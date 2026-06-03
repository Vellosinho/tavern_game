class Armor {
  String armorName;
  double temperatureModifier;
  int weightModifier;

  Armor({required this.armorName, required this.temperatureModifier, required this.weightModifier});
}

// Game armors

Armor yetiArmor = Armor(armorName: "yeti", temperatureModifier: 10, weightModifier: 5);
Armor griffinArmor = Armor(armorName: "griffin", temperatureModifier: 0, weightModifier: 3);