/// Configuration de la barre d'état légère d'Apex-TV.
class ApexThemeStatusBar {
  const ApexThemeStatusBar({
    required this.showClock,
    required this.use24HourClock,
    required this.showWeather,
    required this.showNetwork,
    required this.showNetworkUsage,
    required this.position,
  });

  final bool showClock;
  final bool use24HourClock;
  final bool showWeather;
  final bool showNetwork;
  final bool showNetworkUsage;

  /// `top` ou `bottom`.
  final String position;

  factory ApexThemeStatusBar.fromJson(Map<String, dynamic> json) {
    return ApexThemeStatusBar(
      showClock: _parseBool(json['showClock'], defaultValue: true),
      use24HourClock: _parseBool(json['use24HourClock'], defaultValue: true),
      showWeather: _parseBool(json['showWeather'], defaultValue: true),
      showNetwork: _parseBool(json['showNetwork'], defaultValue: true),
      showNetworkUsage: _parseBool(
        json['showNetworkUsage'],
        defaultValue: false,
      ),
      position: json['position'] == 'bottom' ? 'bottom' : 'top',
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'showClock': showClock,
      'use24HourClock': use24HourClock,
      'showWeather': showWeather,
      'showNetwork': showNetwork,
      'showNetworkUsage': showNetworkUsage,
      'position': position,
    };
  }

  ApexThemeStatusBar copyWith({
    bool? showClock,
    bool? use24HourClock,
    bool? showWeather,
    bool? showNetwork,
    bool? showNetworkUsage,
    String? position,
  }) {
    return ApexThemeStatusBar(
      showClock: showClock ?? this.showClock,
      use24HourClock: use24HourClock ?? this.use24HourClock,
      showWeather: showWeather ?? this.showWeather,
      showNetwork: showNetwork ?? this.showNetwork,
      showNetworkUsage: showNetworkUsage ?? this.showNetworkUsage,
      position: position ?? this.position,
    );
  }

  static bool _parseBool(dynamic value, {required bool defaultValue}) {
    if (value is bool) {
      return value;
    }

    return defaultValue;
  }
}