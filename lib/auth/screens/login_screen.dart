import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_project/auth/auth.dart';
import 'package:personal_project/common/common.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.themeColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            children: [
              Image.asset('assets/images/app-logo.png'),
              const SizedBox(height: 20),
              Expanded(
                child: Center(
                  child: BlocConsumer<AuthCubit, AuthState>(
                    listener: (context, state) {
                      // 오류 다이얼로그 노출
                    },
                    builder: (context, state) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 8,
                        children: OAuthPlatform.values
                            .sublist(0, OAuthPlatform.values.length - 1)
                            .map(
                              (platform) => OAuthButton(
                                platform: platform,
                                loadingWhen: state.maybeWhen(
                                  orElse: () => false,
                                  loading: (currentPlatform) {
                                    return currentPlatform == platform;
                                  },
                                ),
                                onTap: state.maybeWhen(
                                  orElse: () => context
                                      .read<AuthCubit>()
                                      .requestOAuthLogin,
                                  loading: (_) => null,
                                ),
                              ),
                            )
                            .toList(),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
