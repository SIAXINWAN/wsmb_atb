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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAXyUP9oXeE-IhZGlqjR7fkteXlH2lWXOU',
    appId: '1:842171415623:android:d1d8b191f13b13a7954562',
    messagingSenderId: '842171415623',
    projectId: 'wsmb-day1-try1',
    databaseURL: 'https://wsmb-day1-try1-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'wsmb-day1-try1.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyACdWJT9rBUmm4d2hM7wnnCNCsX4Q0z3Hg',
    appId: '1:842171415623:ios:2ee2ead6f7d7c8fa954562',
    messagingSenderId: '842171415623',
    projectId: 'wsmb-day1-try1',
    databaseURL: 'https://wsmb-day1-try1-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'wsmb-day1-try1.appspot.com',
    iosBundleId: 'com.example.wsmbDay2Try1',
  );

}