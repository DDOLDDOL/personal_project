import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:personal_project/auth/auth.dart';

class OAuthButton extends StatelessWidget {
  const OAuthButton({
    super.key,
    required this.platform,
    required this.onTap,
    required this.loadingWhen,
  });

  final OAuthPlatform platform;
  final void Function(OAuthPlatform)? onTap;
  final bool loadingWhen;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap?.call(platform),
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: loadingWhen
            ? Center(
                child: SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    color: _buttonTextStyle.color,
                  ),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Image.network(_iconUrl, height: 28),
                  const SizedBox(width: 24),
                  Text(
                    'Sign in with $_platformToString',
                    style: _buttonTextStyle,
                  ),
                ],
              ),
      ),
    );

    return GestureDetector(
      onTap: () => onTap?.call(platform),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Image.asset(
          'assets/images/$_platformToString-logo.png',
          width: 60,
        ),
      ),
    );
  }

  String get _platformToString {
    return switch (platform) {
      OAuthPlatform.google => 'Google',
      _ => 'Unknown',
      // OAuthPlatform.facebook => 'Facebook',
      // OAuthPlatform.apple => 'Apple',
      // OAuthPlatform.kakao => 'Kakao',
      // OAuthPlatform.naver => 'Naver',
    };
  }

  String get _iconUrl {
    return switch (platform) {
      OAuthPlatform.google =>
        'https://banner2.cleanpng.com/20240111/qtv/transparent-google-logo-colorful-google-logo-with-bold-green-1710929465092.webp',
      _ =>
        'https://banner2.cleanpng.com/20240111/qtv/transparent-google-logo-colorful-google-logo-with-bold-green-1710929465092.webp',
    };
  }

  TextStyle get _buttonTextStyle {
    return switch (platform) {
      OAuthPlatform.google => GoogleFonts.roboto(
          color: Colors.black.withValues(alpha: 54),
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      _ => GoogleFonts.roboto(
          color: Colors.black.withValues(alpha: 54),
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
    };
  }
}
