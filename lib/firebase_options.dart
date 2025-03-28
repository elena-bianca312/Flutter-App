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
    apiKey: 'AIzaSyCA33xszlgy2ch6qo4-fRzUD7HCI4-93L0',
    appId: '1:515083318716:web:aa4133ebdfc56fcc6d27b9',
    messagingSenderId: '515083318716',
    projectId: 'myproject-elena312-ec2b0',
    authDomain: 'myproject-elena312-ec2b0.firebaseapp.com',
    storageBucket: 'myproject-elena312-ec2b0.appspot.com',
    measurementId: 'G-V2EV5ZN578',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBzNS8XEKphvfsENfG2YMNFZi_ILu6SpGk',
    appId: '1:515083318716:android:19a725aea92611ef6d27b9',
    messagingSenderId: '515083318716',
    projectId: 'myproject-elena312-ec2b0',
    storageBucket: 'myproject-elena312-ec2b0.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD5rj3KBNX7XG1DVA2K7zqDJz1WEq9e7YA',
    appId: '1:515083318716:ios:41945d36796ecac26d27b9',
    messagingSenderId: '515083318716',
    projectId: 'myproject-elena312-ec2b0',
    storageBucket: 'myproject-elena312-ec2b0.appspot.com',
    iosClientId: '515083318716-hhabd9hj7os4qjv4f514gderbpoq4k88.apps.googleusercontent.com',
    iosBundleId: 'com.example.myproject',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD5rj3KBNX7XG1DVA2K7zqDJz1WEq9e7YA',
    appId: '1:515083318716:ios:41945d36796ecac26d27b9',
    messagingSenderId: '515083318716',
    projectId: 'myproject-elena312-ec2b0',
    storageBucket: 'myproject-elena312-ec2b0.appspot.com',
    iosClientId: '515083318716-hhabd9hj7os4qjv4f514gderbpoq4k88.apps.googleusercontent.com',
    iosBundleId: 'com.example.myproject',
  );
}
