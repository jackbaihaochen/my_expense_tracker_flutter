// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
      return web;
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDuri6ctFABRrVirKABorgPDizwJ1rBRC8',
    appId: '1:1051393022531:web:add1c60e1e702c1e9a92f6',
    messagingSenderId: '1051393022531',
    projectId: 'flutter-test-project-20240130',
    authDomain: 'flutter-test-project-20240130.firebaseapp.com',
    databaseURL: 'https://flutter-test-project-20240130-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'flutter-test-project-20240130.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAQYHcLuJsadgl03pNtJKqFI97xWxQh6lc',
    appId: '1:1051393022531:android:fa53fbf0d6d0fc229a92f6',
    messagingSenderId: '1051393022531',
    projectId: 'flutter-test-project-20240130',
    databaseURL: 'https://flutter-test-project-20240130-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'flutter-test-project-20240130.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBOWWdWGaYxnjxRwYJmICLQyEOVxjM-NmM',
    appId: '1:1051393022531:ios:51396f16cd2b80d49a92f6',
    messagingSenderId: '1051393022531',
    projectId: 'flutter-test-project-20240130',
    databaseURL: 'https://flutter-test-project-20240130-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'flutter-test-project-20240130.appspot.com',
    iosBundleId: 'com.example.myExpenseTracker',
  );
}
