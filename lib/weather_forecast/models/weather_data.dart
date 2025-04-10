import 'package:personal_project/weather_forecast/weather_forecast.dart';

class WeatherData {
  const WeatherData(
    this.temperature,
    this.humidity,
    this._rainfallPatternFlag,
    this.precipitation,
  );

  /// 현재 기온 (°C)
  final double temperature;

  /// 현재 습도 (%)
  final double humidity;

  final String _rainfallPatternFlag; // 강우 패턴 Flag

  /// 1시간 강우/강설량 (mm)
  final double precipitation;

  WeatherData.fromJson(Map<String, dynamic> data)
      : temperature = double.parse(
          (data['item'] as List)
                  .firstWhere((item) => item['category'] == 'T1H')["obsrValue"]
              as String,
        ),
        humidity = double.parse(
          (data['item'] as List)
                  .firstWhere((item) => item['category'] == 'REH')["obsrValue"]
              as String,
        ),
        _rainfallPatternFlag = (data['item'] as List)
                .firstWhere((item) => item['category'] == 'PTY')["obsrValue"]
            as String,
        precipitation = double.parse(
          (data['item'] as List)
                  .firstWhere((item) => item['category'] == 'RN1')["obsrValue"]
              as String,
        );

  /// 강우 패턴
  RainfallPattern get rainfallPattern {
    return switch (int.tryParse(_rainfallPatternFlag) ?? -1) {
      1 || 5 => RainfallPattern.rain,
      3 || 7 => RainfallPattern.snow,
      2 => RainfallPattern.rainAndSnow,
      4 => RainfallPattern.shower,
      6 => RainfallPattern.sleet,
      _ => RainfallPattern.none,
    };
  }
}
