import 'package:fpdart/fpdart.dart';

import '../errors/app_exception.dart';
import '../types/response_type.dart';

extension TaskEitherNullableExtension on TaskEither<AppException, void> {
  /// Ignores any error and returns `null` instead.
  TaskEither<AppException, void> ignoreErrorWithNull() =>
      orElse((_) => TaskResponse.right(null));
}

extension TaskEitherOptionExtension<R> on TaskEither<AppException, Option<R>> {
  /// Ignores any error and returns [Option.none] instead.
  TaskEither<AppException, Option<R>> ignoreErrorWithNone() => orElse(
    (_) => TaskResponse.right(none()),
  );
}
