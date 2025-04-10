enum WeatherType {
  /// 강수형태
  pty,

  /// 습도
  reh,

  /// 1시간 강수량
  rn1,

  /// 기온
  t1h,
}

// 강우 패턴: PTY 카테고리의 코드
enum RainfallPattern {
  /// 맑음 (0)
  none,

  /// 비 (1, 5=빗방울)
  rain,

  /// 비/눈 (2)
  rainAndSnow,

  /// 눈 (3, 7=눈날림)
  snow,

  /// 소나기 (4, 초단기 예보는 해당사항 없음)
  shower,

  /// 진눈깨비 (60)
  sleet,
}

// 강우/강설량: mm
enum Precipitation {
  none, // 0
  weak, // 1
  medium, // 30
  strong, // 50
}
