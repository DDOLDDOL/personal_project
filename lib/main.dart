import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_api_client/my_api_client.dart';
import 'package:personal_project/auth/auth.dart';
import 'package:personal_project/chat/chat.dart';
import 'package:personal_project/common/common.dart';
import 'package:personal_project/firebase_options.dart';
import 'package:personal_project/home/home.dart';
import 'package:personal_project/location/location.dart';
import 'package:personal_project/translation/translation.dart';
import 'package:personal_project/weather_forecast/weather_forecast.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();


  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

  await Hive.initFlutter();
  await AuthHive.instance.initialize();

  runApp(
    Provider(
      create: (_) => ApiClient(),
      child: const _App(),
    ),
  );
}

// Future<void> countTen() async {
//   final _streamController = StreamController<String>.broadcast();

//   final _subscription = _streamController.stream.listen((e) => print('1${e}1'));

//   Future.microtask(() {
//     _streamController.stream.listen((e) => print('2${e}2'));
//   });
//   final stream = await _streamController.stream;

//   final rs = RangeStream(0, 15).bufferCount(3);
//   final rss = rs.listen(print);

//   for (final i in List.generate(10, (j) => j)) {
//     print('--$i');
//     await Future.delayed(Duration(seconds: 1));
//     _streamController.sink.add(i.toString());
//   }

//   // print(await stream.toList());

//   _streamController.close();
//   _subscription.cancel();
//   rss.cancel();
// }

class _App extends StatelessWidget {
  const _App({super.key});

  @override
  Widget build(BuildContext context) {
    return _MultiRepositoryProvider(
      child: MultiBlocProvider(
        providers: [
          const BlocProvider(create: UserBloc.create),
          BlocProvider(
            create: (context) => AuthCubit(context.read<AuthRepository>()),
          ),
        ],
        child: MaterialApp(
          theme: ThemeData(
            useMaterial3: true,
            appBarTheme: AppBarTheme(
              titleTextStyle: TextStyle(fontSize: 18, color: Colors.black),
              surfaceTintColor: Colors.transparent,
            ),
            scaffoldBackgroundColor: Colors.white,
          ),
          debugShowCheckedModeBanner: false,
          home: const AuthGuard(
            home: HomeScreen(),
            auth: LoginScreen(),
          ),
        ),
      ),
    );
  }
}

class _MultiRepositoryProvider extends StatelessWidget {
  const _MultiRepositoryProvider({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => AuthRepository()),
        RepositoryProvider(create: (_) => ChatRepository()),
        RepositoryProvider(
          create: (context) => WeatherRepository(context.read<ApiClient>()),
        ),
        RepositoryProvider(
          create: (context) => LocationRepository(context.read<ApiClient>()),
        ),
        RepositoryProvider(
          create: (context) => TranslationRepository(context.read<ApiClient>()),
        ),
      ],
      child: child,
    );
  }
}
