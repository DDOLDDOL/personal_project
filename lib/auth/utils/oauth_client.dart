import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:personal_project/auth/auth.dart';
import 'package:personal_project/auth/models/oauth_result.dart';

class OAuthClient {
  OAuthClient()
      : _firebaseAuth = firebase_auth.FirebaseAuth.instance,
        _googleAuth = GoogleSignIn(),
        _oAuthResultController = StreamController.broadcast() {
    _userSubScription =
        _firebaseAuth.authStateChanges().listen(_listenFirebaseAuth);
  }

  final firebase_auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleAuth;
  final StreamController<OAuthResult?> _oAuthResultController;
  late final StreamSubscription<firebase_auth.User?> _userSubScription;

  Stream<OAuthResult?> watchOAuthResult() => _oAuthResultController.stream;

  /// Firebase Auth OAuth 로그인을 진행합니다
  Future<void> login(OAuthPlatform platform) async {
    try {
      final credentialGetter = switch (platform) {
        OAuthPlatform.google => _googleLogin,
        _ => null,
      };

      final oAuthCredential = await credentialGetter?.call();
      if (oAuthCredential == null) return;

      // Firebase google 로그인 요청
      await _firebaseAuth.signInWithCredential(oAuthCredential);
    } on Exception catch (error) {
      print('-------------------------------------------------');
      print(
        'Firebase Auth Error: ${error.toString().split('Exception: ').last}',
      );
      print('-------------------------------------------------');
      rethrow;
    }
  }

  /// Firebase Auth OAuth 및 해당 로그인에서의 로그아웃을 진행합니다
  Future<void> logout(OAuthPlatform platform) async {
    try {
      await _firebaseAuth.signOut();
    } on Exception {
      // 오류 여부와 상관없이 현재 유저 제거
      _oAuthResultController.sink.add(null);
      rethrow;
    } finally {
      // FirebaseAuth의 user stream을 구독 중이기 때문에
      // 우선 FirebaseAuth에서 로그아웃 한 후에 오류 여부와 상관없이 현재 유저를 제거하고
      // 각 플랫폼에서 로그아웃을 진행합니다
      if (platform == OAuthPlatform.google) await _googleAuth.signOut();
    }
  }

  Future<firebase_auth.OAuthCredential?> _googleLogin() async {
    try {
      // Google Web Sign in API 실행
      final googleSignInAccount = await _googleAuth.signIn();

      final authentication = await googleSignInAccount?.authentication;
      if (authentication == null) return null; // 취소했을 때 null

      // 획득한 OAuth Credential 반환
      return firebase_auth.GoogleAuthProvider.credential(
        accessToken: authentication.accessToken,
        idToken: authentication.idToken,
      );
    } on Exception catch (error) {
      print('-------------------------------------------------');
      print(
        'Google Sign in Error: ${error.toString().split('Exception: ').last}',
      );
      print('-------------------------------------------------');
      rethrow;
    }
  }

  Future<void> _listenFirebaseAuth(firebase_auth.User? userData) async {
    if (userData == null) return _oAuthResultController.sink.add(null);

    final data = userData.providerData[0];
    final user = OAuthResult(
      data.uid!,
      data.email!,
      data.providerId!,
      data.displayName,
      data.phoneNumber,
      data.photoURL,
      await userData.getIdToken(),
      userData.refreshToken,
    );

    _oAuthResultController.sink.add(user);
  }

  void close() {
    _oAuthResultController.close();
    _userSubScription.cancel();
  }

  // Future<void> _metaLogin() async {
  //   try {
  //     // Google Web Sign in API 실행
  //     final metaAuthResult = await _facebookAuth.login(
  //       permissions: const ['email', 'public_profile'],
  //     );

  //     // Facebook login result의 access token으로 OAuth Credential 획득
  //     final metaAccessToken = metaAuthResult.accessToken?.token;
  //     if (metaAccessToken == null) return;

  //     // final oAuthResult = OAuthResult(
  //     //   '',
  //     //   'facebook',
  //     //   metaAccessToken ?? '',
  //     // );

  //     // return _controller.sink.add(oAuthResult);

  //     final oAuthCredential = FacebookAuthProvider.credential(metaAccessToken);

  //     // Firebase google 로그인 요청
  //     await _firebaseAuth.signInWithCredential(oAuthCredential);
  //   } on Exception {
  //     rethrow;
  //   }
  // }

  // Future<void> _googleLogout() {
  //   return _googleAuth.signOut();
  // }
  //
  // Future<void> _metaLogout() {
  //   return _facebookAuth.logOut();
  // }

  // Stream<User?> watchUser() => _firebaseAuth.userChanges();
}
