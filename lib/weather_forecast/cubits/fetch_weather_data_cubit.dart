import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:personal_project/weather_forecast/weather_forecast.dart';

part 'fetch_weather_data_state.dart';
part 'fetch_weather_data_cubit.freezed.dart';

class FetchWeatherDataCubit extends Cubit<FetchWeatherDataState> {
  FetchWeatherDataCubit(this._repository)
      : super(const FetchWeatherDataState.initial());

  factory FetchWeatherDataCubit.create(BuildContext context) {
    return FetchWeatherDataCubit(context.read<WeatherRepository>());
  }

  factory FetchWeatherDataCubit.of(BuildContext context) {
    return context.read<FetchWeatherDataCubit?>() ?? FetchWeatherDataCubit.create(context);
  }

  final WeatherRepository _repository;

  Future<void> fetchWeatherData(String nx, String ny) async {
    emit(const FetchWeatherDataState.loading());

    try {
      final weatherData = await _repository.fetchWeatherData(nx, ny);
      emit(FetchWeatherDataState.loaded(weatherData));
    } on Exception catch (exception) {}
    // } on ApiException catch (exception) {
      // exception.whenOrNull();
    // }
  }
}
