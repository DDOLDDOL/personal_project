import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:personal_project/location/location.dart';

part 'fetch_location_data_state.dart';
part 'fetch_location_data_cubit.freezed.dart';

class FetchLocationDataCubit extends Cubit<FetchLocationDataState> {
  FetchLocationDataCubit(this._repository)
      : super(const FetchLocationDataState.initial());

  factory FetchLocationDataCubit.create(BuildContext context) {
    return FetchLocationDataCubit(context.read<LocationRepository>());
  }

  factory FetchLocationDataCubit.of(BuildContext context) {
    return context.read<FetchLocationDataCubit?>() ??
        FetchLocationDataCubit.create(context);
  }

  final LocationRepository _repository;

  Future<void> fetchCurrentLocationDataByLatLng(
    double latitude,
    double longitude,
  ) async {
    emit(const FetchLocationDataState.loading());

    try {
      final locationData = await _repository.fetchCurrentLocationDataByLatLng(
        latitude,
        longitude,
      );
      emit(FetchLocationDataState.loaded(locationData));
    // } on ApiException catch (exception) {}
    } on Exception catch (exception) {}
  }
}
