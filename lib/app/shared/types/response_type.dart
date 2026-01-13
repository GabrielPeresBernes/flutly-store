import 'package:fpdart/fpdart.dart';

import '../errors/app_exception.dart';

typedef Response<T> = Either<AppException, T>;

typedef FutureResponse<T> = Future<Response<T>>;

typedef TaskResponse<T> = TaskEither<AppException, T>;
