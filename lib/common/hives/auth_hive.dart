import 'package:hive_flutter/hive_flutter.dart';
import 'package:personal_project/auth/auth.dart';

class AuthHive {
  // Singleton 패턴 작성을 위해 생성자를 감춥니다
  AuthHive._();

  // AuthHive 내부 클래스 객체 멤버입니다
  static final _instance = AuthHive._();

  /// User Auth를 위한 JWT 저장소입니다
  ///
  /// Singleton 클래스이므로 instance를 호출해 인스턴스 멤버를 사용할 수 있습니다
  static AuthHive get instance => _instance;

  // 토큰 저장 Box - 클래스 멤버 _instance에 종속되어 모든 instance에 공유됩니다
  Box<String?>? _box;

  final _boxKey = "TOKEN_BOX"; // _box를 열기 위한 Key
  final _accessTokenKey = "ACCESS_TOKEN"; // 액세스 토큰 저장 키
  final _refreshTokenKey = "REFRESH_TOKEN"; // 리프레쉬 토큰 저장 키
  final _userIdKey = "USER_ID"; // 계정 ID 저장 키
  final _emailKey = "EMAIL"; // 내 이메일 주소 저장 키
  final _oAuthProviderKey = "OAUTH_PLATFORM"; // oauth 플랫폼 키

  /// 내부 인스턴스 멤버 _box를 초기화합니다
  ///
  /// 최초 생성 시에 반드시 호출해야 합니다
  Future<void> initialize() async {
    if (!(_box?.isOpen ?? false)) _box = await Hive.openBox(_boxKey);
  }

  // 액세스 토큰 Getter
  String? get accessToken => _box!.get(_accessTokenKey, defaultValue: null);

  // 리프레쉬 토큰 Getter
  String? get refreshToken => _box!.get(_refreshTokenKey, defaultValue: null);

  // 계정 ID Getter
  String? get userId => _box!.get(_userIdKey, defaultValue: null);

  // 내 이메일 주소 Getter
  String? get email => _box!.get(_emailKey, defaultValue: null);

  // OAuth 제공 플랫폼
  OAuthPlatform? get oAuthProvider {
    return switch (_box!.get(_oAuthProviderKey, defaultValue: 'Unknown')!) {
      'google.com' => OAuthPlatform.google,
      _ => OAuthPlatform.unknown,
    };
  }

  /// 액세스 토큰을 업데이트합니다
  Future<void> setAccessToken(String? accessToken) {
    return _box!.put(_accessTokenKey, accessToken);
  }

  /// 리프레쉬 토큰을 업데이트합니다
  Future<void> setRefreshToken(String? refreshToken) {
    return _box!.put(_refreshTokenKey, refreshToken);
  }

  /// 계정 ID를 업데이트합니다
  Future<void> setUserId(String? userId) {
    return _box!.put(_userIdKey, userId);
  }

  // OAuth 제공 플랫폼을 업데이트합니다
  Future<void> setEmail(String? email) {
    return _box!.put(_emailKey, email);
  }

  // OAuth 제공 플랫폼을 업데이트합니다
  Future<void> setOAuthProvider(String? oAuthProvider) {
    return _box!.put(_oAuthProviderKey, oAuthProvider);
  }

  /// 저장소를 업데이트합니다
  Future<void> clear() async {
    await setAccessToken(null);
    await setRefreshToken(null);
    await setUserId(null);
    await setEmail(null);
    await setOAuthProvider(null);
  }
}
