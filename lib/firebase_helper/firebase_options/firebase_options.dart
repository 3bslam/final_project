import 'dart:io';

import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseConfig {
  static FirebaseOptions get platformOptions {
    if (Platform.isIOS) {
      // iOS and MacOS
      return const FirebaseOptions(
        appId: '1:996378840536:android:65636bb2d64a23cc1436ad',
        apiKey: 'AIzaSyB6f4pyu_AikUNCONwZ1b8PhvuN-5Xr5_Q',
        projectId: 'final-project-e79ed',
        messagingSenderId: '996378840536',
        
      );
      
    } else {
      // Android
      return const FirebaseOptions(
        appId: '1:996378840536:android:65636bb2d64a23cc1436ad',
        apiKey: 'AIzaSyB6f4pyu_AikUNCONwZ1b8PhvuN-5Xr5_Q',
        projectId: 'final-project-e79ed',
        messagingSenderId: '996378840536',
      );
    }
  }
}
