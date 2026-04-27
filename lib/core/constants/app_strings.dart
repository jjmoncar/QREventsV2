class AppStrings {
  AppStrings._();

  static const String appName = 'Guestly';

  // Event types
  static const List<String> eventTypes = [
    'boda',
    'cumpleanos',
    'corporativo',
    'quinceanera',
    'graduacion',
    'concierto',
    'otro',
  ];

  static const Map<String, String> eventTypeLabels = {
    'boda': 'Boda',
    'cumpleanos': 'Cumpleaños',
    'corporativo': 'Corporativo',
    'quinceanera': 'Quinceañera',
    'graduacion': 'Graduación',
    'concierto': 'Concierto',
    'otro': 'Otro',
  };

  static const Map<String, String> eventTypeIcons = {
    'boda': '💒',
    'cumpleanos': '🎂',
    'corporativo': '🏢',
    'quinceanera': '👑',
    'graduacion': '🎓',
    'concierto': '🎵',
    'otro': '🎉',
  };
}
