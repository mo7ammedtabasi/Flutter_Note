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
        return macos;
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
    apiKey: 'AIzaSyDObJUgxdLqLl0-8bkINNs050srnWrAAeI',
    appId: '1:1047313019802:web:4b700105d48b364d590023',
    messagingSenderId: '1047313019802',
    projectId: 'flutter-project-2dd3c',
    authDomain: 'flutter-project-2dd3c.firebaseapp.com',
    databaseURL: 'https://flutter-project-2dd3c-default-rtdb.firebaseio.com',
    storageBucket: 'flutter-project-2dd3c.appspot.com',
    measurementId: 'G-P97NQP2STJ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBCsiQ-V5BCsKPrKHEqfImFl7rGSZSguZQ',
    appId: '1:1047313019802:android:744f7f8ea2d981bd590023',
    messagingSenderId: '1047313019802',
    projectId: 'flutter-project-2dd3c',
    databaseURL: 'https://flutter-project-2dd3c-default-rtdb.firebaseio.com',
    storageBucket: 'flutter-project-2dd3c.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA0j5mxSMR3SgNcfFi0_h3CLr35SDf2rH0',
    appId: '1:1047313019802:ios:ef7e17e0fbd6197f590023',
    messagingSenderId: '1047313019802',
    projectId: 'flutter-project-2dd3c',
    databaseURL: 'https://flutter-project-2dd3c-default-rtdb.firebaseio.com',
    storageBucket: 'flutter-project-2dd3c.appspot.com',
    androidClientId: '1047313019802-53mvs48tvlv94aqj8ohrffc09qt24fuf.apps.googleusercontent.com',
    iosClientId: '1047313019802-9umdemgpfa10bq7nhrno1nf0p2tqnau1.apps.googleusercontent.com',
    iosBundleId: 'com.mo7ammedtabasi.note',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA0j5mxSMR3SgNcfFi0_h3CLr35SDf2rH0',
    appId: '1:1047313019802:ios:e1a2e657b549ef90590023',
    messagingSenderId: '1047313019802',
    projectId: 'flutter-project-2dd3c',
    databaseURL: 'https://flutter-project-2dd3c-default-rtdb.firebaseio.com',
    storageBucket: 'flutter-project-2dd3c.appspot.com',
    androidClientId: '1047313019802-53mvs48tvlv94aqj8ohrffc09qt24fuf.apps.googleusercontent.com',
    iosClientId: '1047313019802-m191mpffj83obd09s76r2df088b4in2a.apps.googleusercontent.com',
    iosBundleId: 'com.mo7ammedtabasi.note.RunnerTests',
  );
}