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
    apiKey: 'AIzaSyAupqhIl2i6luQ',
    appId: '1:45159471:web:25581707a',
    messagingSenderId: '45159431',
    projectId: 'mycattlemonitor',
    authDomain: 'mycattlemonitor.firebaseapp.com',
    storageBucket: 'mycattlemonitor.firebasestorage.app',
    measurementId: 'G-5K2P',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC9T4pOKp3ivI__fJtY0',
    appId: '1:45159471:androebe84707a',
    messagingSenderId: '4231',
    projectId: 'mycattlemonitor',
    storageBucket: 'mycattlemonitor.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAgBJp8VpB0MeA',
    appId: '1:45159472:1b51707a',
    messagingSenderId: '451594729231',
    projectId: 'mycattlemonitor',
    storageBucket: 'mycattlemonitor.firebasestorage.app',
    iosBundleId: 'com.example.mycowmanager',
  );

}