import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
          'DefaultFirebaseOptions have not been configured for macOS - '
          'it is not supported by FlutLab yet, but you can add it manually',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'it is not supported by FlutLab yet, but you can add it manually',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'it is not supported by FlutLab yet, but you can add it manually',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR_IOS_API_KEY',
    appId: 'YOUR_IOS_APP_ID',
    messagingSenderId: 'YOUR_IOS_MESSAGING_SENDER_ID',
    projectId: 'wordstime-f42b8',
    storageBucket: 'wordstime-f42b8.appspot.com',
    iosClientId: 'YOUR_IOS_CLIENT_ID',
    iosBundleId: 'com.example.parolando',
    databaseURL:
        'https://wordstime-f42b8-default-rtdb.europe-west1.firebasedatabase.app', // URL corretto
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCQ80zi3AUeBbBzwE9yaGR2sWmvqEBy9CQ',
    appId: '1:213470521905:android:0180b0237a1cc6e04e4310',
    messagingSenderId: '213470521905',
    projectId: 'wordstime-f42b8',
    storageBucket: 'wordstime-f42b8.appspot.com',
    databaseURL:
        'https://wordstime-f42b8-default-rtdb.europe-west1.firebasedatabase.app', // URL corretto
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'YOUR_WEB_API_KEY',
    authDomain: 'YOUR_WEB_AUTH_DOMAIN',
    messagingSenderId: 'YOUR_WEB_MESSAGING_SENDER_ID',
    projectId: 'wordstime-f42b8',
    storageBucket: 'wordstime-f42b8.appspot.com',
    appId: 'YOUR_WEB_APP_ID',
    databaseURL:
        'https://wordstime-f42b8-default-rtdb.europe-west1.firebasedatabase.app', // URL corretto
  );
}
