import 'package:intl/intl.dart';
import 'package:my_api_client/my_api_client.dart';
import 'package:personal_project/weather_forecast/weather_forecast.dart';

class WeatherRepository {
  const WeatherRepository(this._client);

  final ApiClient _client;

  Future<WeatherData> fetchWeatherData(String nx, String ny) async {
    final date = DateFormat('yyyyMMdd').format(DateTime.now());
    final time = DateFormat('HHmm').format(DateTime.now());

    final apiUrl = _generateWeatherForecastApiUrl(date, time, nx, ny);
    final response = await _client.get(apiUrl);

    if (response.hasException) throw response.exception!;
    return WeatherData.fromJson(response.data['response']['body']["items"]);
  }

  String _generateWeatherForecastApiUrl(
    String date,
    String time,
    String nx,
    String ny,
  ) {
    const serviceKeyParamter =
        "serviceKey=tcsBNpATjD5aZ1L3W9T37CvfzcQ9fIgyOf7%2B%2B1Q1OEb7hyUcuT%2FOHJ4pVbu8UwqqrKq9IotLZ4gz21gGalza1w%3D%3D";
    final dateTimeParameter = "base_date=$date&base_time=$time";
    final nxNyParameter = "&nx=$nx&ny=$ny";

    return "$weatherForecastApiUrl?$serviceKeyParamter&$dateTimeParameter&$nxNyParameter&numOfRows=10&pageNo=1&dataType=JSON";
  }
}
