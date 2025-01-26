import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:personal_project/auth/auth.dart';
import 'package:personal_project/auth/models/oauth_result.dart';
import 'package:personal_project/auth/utils/oauth_client.dart';
import 'package:personal_project/common/common.dart';

class AuthRepository {
  AuthRepository()
      : _tokenHive = TokenHive.instance,
        _oAuthClient = OAuthClient(),
        _database = FirebaseFirestore.instance,
        _userController = StreamController.broadcast() {
    _oAuthResultSubscription =
        _oAuthClient.watchOAuthResult().listen(_listenOAuthResult);
  }

  final TokenHive _tokenHive;
  final OAuthClient _oAuthClient;
  final FirebaseFirestore _database;
  final StreamController<User?> _userController;
  late final StreamSubscription<OAuthResult?> _oAuthResultSubscription;

  Future<void> requestOAuthLogin(OAuthPlatform platform) async {
    try {
      await _oAuthClient.login(platform);
    } on Exception {
      rethrow;
    }
  }

  /// logout 요청입니다.
  Future<void> logout(OAuthPlatform? platform) async {
    try {
      if (platform == null) throw Exception('로그인 정보가 만료되었습니다');
      await _oAuthClient.logout(platform);
    } on Exception catch (error) {
      print(error.toString());
    }
  }

  Future<User> fetchUser(String userId) async {
    try {
      final document = await _database.collection('users').doc(userId).get();

      if (document.data() == null) throw Exception('$userId 유저 정보가 없습니다');
      return User.fromJson(document.data()!);
    } on Exception {
      rethrow;
    }
  }

  /// 최초 로그인 시에 호출되었을 경우에는 FireStore DB에 유저를 등록하고,
  /// 그 이후부터는 유저 정보를 수정합니다
  Future<void> updateUser(User user) async {
    try {
      await _database.collection('users').doc(user.id).set(user.toJson());
    } on Exception {
      rethrow;
    }
  }

  Future<void> _listenOAuthResult(OAuthResult? result) async {
    print('----------user state changed-------------');
    if (result == null) {
      await _tokenHive.clear();
      return _userController.sink.add(null);
    }

    final user = User(
      result.userId,
      result.email,
      result.username,
      result.phone,
      result.oAuthProvider,
    );

    await _tokenHive.setAccessToken(result.firebaseIdToken);
    await _tokenHive.setRefreshToken(result.firebaseRefreshToken);
    _userController.sink.add(user);
  }

  Stream<User?> watchUser() => _userController.stream;

  void close() {
    _userController.close();
    _oAuthClient.close();
    _oAuthResultSubscription.cancel();
  }

  /// login 요청입니다.
  ///
  /// 계정 ID와 비밀번호를 인증하고 jwt token을 받아 [TokenHive]에 저장합니다.
  // Future<void> login(String accountId, String password) async {
  // if (accountId.isEmpty) {
  //   throw const ApiException.apiError(400, message: '아이디를 입력해주세요');
  // }

  // if (password.isEmpty) {
  //   throw const ApiException.apiError(400, message: '비밀번호를 입력해주세요');
  // }

  // // 아이디, 비밀번호 일치 시 jwt 토큰 발급
  // final response = await _apiClient.post(
  //   '/api/login/',
  //   body: {
  //     "username": accountId,
  //     "password": password,
  //   },
  // );

  // if (response.hasException) throw response.exception!;

  // final accessToken = response.data?['jwt_token']['access_token'] as String?;
  // final encryptedRefreshToken =
  //     response.data?['jwt_token']['encrypt_refresh_token_id'] as String?;

  // if (accessToken == null || encryptedRefreshToken == null) {
  //   throw Exception('로그인 정보를 불러오는 데 실패했습니다');
  // }

  // await _tokenHive.setTokens(accessToken, encryptedRefreshToken);
  // }

  // /// 유저 정보를 불러옵니다.
  // ///
  // /// [TokenHive]가 비어있으면 unknown user를, 그렇지 않으면 user fetch 요청을 보냅니다.
  // /// [User] 결과 값은 [watchUser] stream을 통해 broadcast 됩니다.
  // Future<void> fetchUser() async {
  //   // 앱을 켰을 때도 한 번 실행되므로, token hive가 비어있으면 (로그아웃 상태일 시)에는 [User.unknown]을 반환합니다
  //   if (_tokenHive.encryptedRefreshToken == null) {
  //     return _userStreamController.sink.add(User.unknown());
  //   }

  //   final response = await _apiClient.get('/api/user-info/', needAuth: true);
  //   if (response.hasException) throw response.exception!;

  //   _userStreamController.sink.add(User.fromJson(response.data!));
  // }

  // /// [fetchUser] 결과로 나온 [User] 값을 broadcast 해주는 stream입니다
  // Stream<User> watchUser() => _userStreamController.stream;

  /// [firebase_auth.User] 값을 broadcast 해주는 stream입니다
  // Stream<firebase_auth.User?> watchFirebaseAuthUser() =>
  //     _oAuthClient.watchUser();

  // Future<void> _revokeRefreshToken() async {
  //   // TokenHive를 초기화 시킨 후에 호출하므로, 동기화 후 exception handling 할 필요가 없어서
  //   // 예외 발생 시 repository에서 로그만 찍습니다
  //   try {
  //     final encryptedRefreshToken = _tokenHive.encryptedRefreshToken;
  //     if (encryptedRefreshToken == null) return;

  //     final response = await _apiClient.post(
  //       '/api/logout/',
  //       needAuth: true,
  //       body: {
  //         'encrypt_refresh_token_id': encryptedRefreshToken,
  //       },
  //     );

  //     if (response.hasException) throw response.exception!;
  //   } on ApiException catch (error) {
  //     log('Refresh token revoking error: $error');
  //   } on Exception catch (error) {
  //     log('Refresh token revoking error: $error');
  //   }
  // }
}
