import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_project/auth/auth.dart';

class AuthGuard extends StatelessWidget {
  const AuthGuard({
    super.key,
    required this.auth,
    required this.home,
  });

  final Widget auth;
  final Widget home;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {
        if (state.hasError) {
          // 오류 dialog 노출
          print('oauth error!!! ${state.errorMessage}');
        }
      },
      builder: (_, state) {
        if (state.user != null) return home;
        return auth;
      },
    );

    // return MultiBlocListener(
    //   listeners: [
    //     BlocListener<UserBloc, UserState>(
    //       listenWhen: (_, current) {
    //         return current.maybeWhen(
    //           orElse: () => false,
    //           authorized: () => true,
    //         );
    //       },
    //       listener: (context, _) {
    //         Navigator.of(context).popUntil((route) => route.isFirst);
    //         context.read<UserBloc>().add(const UserEvent.userFetchRequested());
    //       },
    //     ),
    //     BlocListener<UserBloc, UserState>(
    //       listenWhen: (_, current) {
    //         return !current.hasError &&
    //             !current.unknownUser &&
    //             (current.user?.isInvalid ?? false);
    //       },
    //       listener: (context, _) {
    //         showInvalidUserAlertSheet(context: context);
    //       },
    //     ),
    //   ],
    //   child: UserBuilder(
    //     onFetching: (_) => const _FetchingView(),
    //     onLoaded: (_, user) {
    //       if (user.isInvalid) return invalid(user); // User 정보 충족 여부 먼저 점검
    //       if (!user.isEmailActivated)
    //         return inactivated(user.email); // 후에 이메일 미인증 점검
    //       return authorized;
    //     },
    //     onUnknownUser: (_) => unauthorized,
    //     onError: (_, message) => error(message),
    //   ),
    // );
  }
}

class _FetchingView extends StatelessWidget {
  const _FetchingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
