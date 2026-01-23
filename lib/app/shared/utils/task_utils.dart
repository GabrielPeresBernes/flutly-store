import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:fpdart/fpdart.dart';

import '../errors/app_exception.dart';
import '../types/response_type.dart';

/// Utility function to execute a task with error handling,
/// returning a [TaskResponse].
TaskResponse<T> task<T>(
  Future<T> Function() run,
  String Function(Object error) onError,
) => TaskEither.tryCatch(
  run,
  (error, stackTrace) {
    try {
      FirebaseCrashlytics.instance.recordError(error, stackTrace);
    } catch (_) {
      /* Ignore Crashlytics errors */
    }

    return AppException(
      message: onError(error),
      details: error,
      stackTrace: stackTrace,
    );
  },
);
