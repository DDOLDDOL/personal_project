part of 'fetch_location_data_cubit.dart';

@freezed
class FetchLocationDataState with _$FetchLocationDataState{
  const factory FetchLocationDataState.initial() = _Initial;
  const factory FetchLocationDataState.loading() = _Loading;
  const factory FetchLocationDataState.loaded(LocationData locationData) = _Loaded;
  const factory FetchLocationDataState.error(String message, String reason) = _Error;
}