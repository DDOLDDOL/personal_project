part of 'fetch_weather_data_cubit.dart';

@freezed
class FetchWeatherDataState with _$FetchWeatherDataState {
  const factory FetchWeatherDataState.initial() = _Initial;
  const factory FetchWeatherDataState.loading() = _Loading;
  const factory FetchWeatherDataState.loaded(WeatherData weatherData) = _Loaded;
  const factory FetchWeatherDataState.error(String message, String reason) = _Error;
}