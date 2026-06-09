class MapClimate{
  final double baseTemperature;
  final double temperatureModifier;

  MapClimate({required this.baseTemperature, required this.temperatureModifier});
}

MapClimate mild = MapClimate(baseTemperature: 24, temperatureModifier: 1);
MapClimate mildOutside = MapClimate(baseTemperature: 24, temperatureModifier: 2);
MapClimate desert = MapClimate(baseTemperature: 36, temperatureModifier: 2);
MapClimate snow = MapClimate(baseTemperature: 5, temperatureModifier: 1);
