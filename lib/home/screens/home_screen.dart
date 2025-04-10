import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_project/auth/auth.dart';
import 'package:personal_project/chat/screens/chatting_room_list_screen.dart';
import 'package:personal_project/chat/screens/user_search_screen.dart';
import 'package:personal_project/common/common.dart';
import 'package:personal_project/translation/translation.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SpeechToTextBloc(
            context.read<TranslationRepository>(),
          )..add(const SpeechToTextEvent.initRequired()),
        ),
        BlocProvider(
          create: (context) => TranslateCubit(
            context.read<TranslationRepository>(),
          ),
        ),
        BlocProvider(
          create: (context) => TextToSpeechBloc(
            context.read<TranslationRepository>(),
          ),
        ),
      ],
      child: const _View(),
    );
  }
}

class _View extends StatelessWidget {
  const _View({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // SubmitButton(
              //   onPressed: () {
              //     context
              //         .read<SpeechToTextBloc>()
              //         .add(const SpeechToTextEvent.listenRequired());
              //   },
              //   child: const Text('Start Recording'),
              // ),
              // const SizedBox(height: 20),
              // SubmitButton(
              //   onPressed: () {
              //     Navigator.of(context).push(
              //       MaterialPageRoute(
              //         builder: (_) => const ChattingRoomListScreen(),
              //       ),
              //     );
              //   },
              //   child: const Text('Go to Chat List'),
              // ),
              // const SizedBox(height: 20),
              SubmitButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ChattingRoomListScreen()),
                  );
                },
                child: const Text('Chat'),
              ),
              // const SizedBox(height: 20),
              // BlocConsumer<SpeechToTextBloc, SpeechToTextState>(
              //   listener: (context, state) {
              //     state.whenOrNull(
              //       done: (generated) {
              //         context
              //             .read<TranslateCubit>()
              //             .translate([generated], 'EN');
              //       },
              //     );
              //   },
              //   builder: (_, state) {
              //     return Text(state.toString());
              //   },
              // ),
              // const SizedBox(height: 20),
              // SubmitButton(
              //   onPressed: () {
              //     // repo.translate('만나서 반갑습니다', 'kr', 'en');
              //     context.read<TranslateCubit>().translate(
              //       [
              //         'I am hungry',
              //         'Hello. Nice to meet you',
              //       ],
              //       'KO',
              //     );
              //   },
              //   child: const Text('Translate'),
              // ),
              // BlocConsumer<TranslateCubit, TranslateState>(
              //   listener: (context, state) {
              //     state.whenOrNull(
              //       done: (result) {
              //         context
              //             .read<TextToSpeechBloc>()
              //             .add(TextToSpeechEvent.playRequested(result));
              //       },
              //     );
              //   },
              //   builder: (_, state) {
              //     return Text(state.toString());
              //   },
              // ),
              const SizedBox(height: 20),
              SubmitButton(
                onPressed: context.read<AuthCubit>().logout,
                child: const Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         const BlocProvider(create: FetchWeatherDataCubit.create),
//         BlocProvider(
//           create: (context) => FetchLocationDataCubit.create(context)
//             ..fetchCurrentLocationDataByLatLng(37.53093, 127.1480),
//         ),
//       ],
//       child: const _Content(),
//     );
//   }
// }

// class _Content extends StatelessWidget {
//   const _Content({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocListener(
//       listeners: [
//         BlocListener<FetchLocationDataCubit, FetchLocationDataState>(
//           listener: (_, state) {
//             state.whenOrNull(
//               loaded: (locationData) {
//                   context.read<FetchWeatherDataCubit>().fetchWeatherData(
//                         locationData.nx,
//                         locationData.ny,
//                       );
//               },
//             );
//           },
//         ),
//       ],
//       child: Scaffold(
//         body: Column(
//           children: [
//             _Header(),
//             _Body(),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _Header extends StatelessWidget {
//   const _Header({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return  BlocBuilder<FetchLocationDataCubit, FetchLocationDataState>(
//       builder: (context, state) {
//         return state.maybeWhen(
//           orElse: SizedBox.shrink,
//           loaded: (weatherData) {
//             return WrapperContainer(
//               child: Text('${weatherData.address}'),
//             );
//           },
//         );
//       },
//     );
//   }
// }

// class _Body extends StatelessWidget {
//   const _Body({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<FetchWeatherDataCubit, FetchWeatherDataState>(
//       builder: (context, state) {
//         return state.maybeWhen(
//           orElse: SizedBox.shrink,
//           loaded: (weatherData) {
//             return WrapperContainer(
//               child: Text('${weatherData.temperature}'),
//             );
//           },
//         );
//       },
//     );
//   }
// }
