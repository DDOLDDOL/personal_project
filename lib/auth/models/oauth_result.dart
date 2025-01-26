class OAuthResult {
  OAuthResult(
    this.userId,
    this.email,
    this.oAuthProvider,
    this.username,
    this.phone,
    this.profileImageUrl,
    this.firebaseIdToken,
    this.firebaseRefreshToken,
  );

  final String userId;
  final String email;
  final String oAuthProvider;
  final String? username;
  final String? phone;
  final String? profileImageUrl;
  final String? firebaseIdToken;
  final String? firebaseRefreshToken;
}
