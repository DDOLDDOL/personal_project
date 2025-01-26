import 'package:personal_project/auth/auth.dart';

class User {
  const User(this.id, this.email, this.name, this.phone, this._oAuthDomain);

  User.fromJson(Map<String, dynamic> data)
      : id = data['id'] as String,
        email = data['email'] as String,
        name = data['name'] as String?,
        phone = data['phone'] as String?,
        _oAuthDomain = data['oAuthProvider'] as String;

  final String id;
  final String email;
  final String? name;
  final String? phone;
  final String _oAuthDomain;

  OAuthPlatform get oAuthPlatform {
    return switch (_oAuthDomain) {
      'google.com' => OAuthPlatform.google,
      _ => OAuthPlatform.unknown,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'oAuthProvider': _oAuthDomain,
      if (name != null) 'name': name!,
      if (phone != null) 'phone': phone!,
    };
  }
}
