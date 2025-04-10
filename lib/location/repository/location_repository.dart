import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:my_api_client/my_api_client.dart';
import 'package:personal_project/location/location.dart';

class LocationRepository {
  const LocationRepository(this._client);

  final ApiClient _client;

  Future<LocationData> fetchCurrentLocationDataByLatLng(
    double latitude,
    double longitude,
  ) async {
    final response = await _client.get(
      '$kakaoReverseGeocodingApiUrl?x=$longitude&y=$latitude',
      options: Options(
        headers: {"Authorization": "KakaoAK $kakaoRestApiKey"},
      ),
    );

    if (response.hasException) throw response.exception!;

    final targetData = (response.data?["documents"] as List?)?.where(
      (data) => data["region_type"] == "H",
    ).firstOrNull as Map<String, dynamic>?;

    if (targetData == null) {
      throw Exception();
      // throw const ApiException.apiError(
      //   404,
      //   message: '현재 위치 정보를 확인할 수 없습니다',
      // );
    }

    final (nx, ny) = _convertAdministrativeCodeToNxNy(targetData['code']);
    return LocationData(latitude, longitude, nx, ny, targetData["address_name"] as String?);
  }

  (String, String) _convertAdministrativeCodeToNxNy(String administrativeCode) {
    return ('55', '127');
  }
}
