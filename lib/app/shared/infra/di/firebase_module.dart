// ignore_for_file: cascade_invocations

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../firebase_options.dart';
import '../../../core/injector/injector.dart';

/// Firebase dependency injection module
class FirebaseModule extends InjectorModule {
  const FirebaseModule();

  @override
  Future<void> register(CoreInjector injector) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await GoogleSignIn.instance.initialize();

    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

    injector.registerSingleton<FirebaseAuth>(FirebaseAuth.instance);

    injector.registerSingleton<GoogleSignIn>(GoogleSignIn.instance);

    injector.registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance);

    injector.registerSingleton<FirebaseCrashlytics>(
      FirebaseCrashlytics.instance,
    );
  }
}
