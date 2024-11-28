// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAuB2XVHmWb2Dl7zrdLktBMDDqCT-kP9T8',
    appId: '1:44317517049:ios:ad366698ad58989d8c2e28',
    messagingSenderId: '44317517049',
    projectId: 'petcy-fb6e0',
    storageBucket: 'petcy-fb6e0.firebasestorage.app',
    iosBundleId: 'com.ddolddol.personalProject',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAP_LIypPWOHmE-E0s4_777JY2LUK5dPgE',
    appId: '1:44317517049:android:3bd2e3926d1ae6138c2e28',
    messagingSenderId: '44317517049',
    projectId: 'petcy-fb6e0',
    storageBucket: 'petcy-fb6e0.firebasestorage.app',
  );

}