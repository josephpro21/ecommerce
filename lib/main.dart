import 'dart:io';

// import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'Login/SignUp/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: "AIzaSyDs7DXH3fsOiPuoPXZ1TlO9E_N_eIhRtLc",
              appId: "1:848437743900:android:3908aba0bcfb9f3747ead9",
              messagingSenderId: "848437743900",
              projectId: "testtwo-3986b",
              storageBucket: "gs://testtwo-3986b.appspot.com"),
        )
      : await Firebase.initializeApp();
  // await FirebaseAppCheck.instance.activate(
  //   // You can also use a `ReCaptchaEnterpriseProvider` provider instance as an
  //   // argument for `webProvider`
  //   webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
  //   // Default provider for Android is the Play Integrity provider. You can use the "AndroidProvider" enum to choose
  //   // your preferred provider. Choose from:
  //   // 1. Debug provider
  //   // 2. Safety Net provider
  //   // 3. Play Integrity provider
  //   androidProvider: AndroidProvider.playIntegrity,
  //   // Default provider for iOS/macOS is the Device Check provider. You can use the "AppleProvider" enum to choose
  //   // your preferred provider. Choose from:
  //   // 1. Debug provider
  //   // 2. Device Check provider
  //   // 3. App Attest provider
  //   // 4. App Attest provider with fallback to Device Check provider (App Attest provider is only available on iOS 14.0+, macOS 14.0+)
  //   // appleProvider: AppleProvider.appAttest,
  // );

  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: DisplayPage(),
  ));
}
