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
        return macos;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
      apiKey: "AIzaSyBUn0dEzXxsTDnAAZS5BEcn0sH8kpJLajQ",
      authDomain: "my-news-8c9b6.firebaseapp.com",
      projectId: "my-news-8c9b6",
      storageBucket: "my-news-8c9b6.firebasestorage.app",
      messagingSenderId: "188761826334",
      appId: "1:188761826334:web:894eca4aa7604a2d6efa0f",
      measurementId: "G-NXRHSK6RWD"
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDFKz75b7ITU5iwk6IUh7VZNSaEmyz7uGg',
    appId: '1:188761826334:android:428be6555c40c5f56efa0f',
    messagingSenderId: '188761826334',
    projectId: 'my-news-8c9b6',
    storageBucket: 'my-news-8c9b6.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR_IOS_API_KEY',
    appId: 'YOUR_IOS_APP_ID',
    messagingSenderId: 'YOUR_IOS_MESSAGING_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'YOUR_IOS_STORAGE_BUCKET',
    iosClientId: 'YOUR_IOS_CLIENT_ID',
    iosBundleId: 'YOUR_IOS_BUNDLE_ID',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'YOUR_MACOS_API_KEY',
    appId: 'YOUR_MACOS_APP_ID',
    messagingSenderId: 'YOUR_MACOS_MESSAGING_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'YOUR_MACOS_STORAGE_BUCKET',
    iosClientId: 'YOUR_MACOS_CLIENT_ID',
    iosBundleId: 'YOUR_MACOS_BUNDLE_ID',
  );
}
