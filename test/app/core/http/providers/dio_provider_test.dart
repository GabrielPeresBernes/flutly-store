import 'package:dio/dio.dart';
import 'package:flutly_store/app/core/http/lib/errors/http_exception.dart';
import 'package:flutly_store/app/core/http/lib/providers/dio_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late Dio dio;
  late DioProvider provider;

  setUp(() {
    dio = MockDio();
    provider = DioProvider(dio);
  });

  Response<dynamic> buildResponse({
    required String path,
    required int? statusCode,
    dynamic data,
  }) => Response<dynamic>(
    requestOptions: RequestOptions(path: path),
    statusCode: statusCode,
    data: data,
  );

  test('get returns decoded response data and passes headers', () async {
    final response = buildResponse(
      path: '/test',
      statusCode: 200,
      data: <String, dynamic>{'id': 1},
    );

    when(
      () => dio.get<dynamic>(
        '/test',
        queryParameters: any(named: 'queryParameters'),
        options: any(named: 'options'),
      ),
    ).thenAnswer((_) async => response);

    Map<String, dynamic>? capturedJson;

    final result = await provider.get<String>(
      '/test',
      queryParameters: <String, dynamic>{'q': '1'},
      headers: <String, String>{'x-token': 'abc'},
      decoder: (json) {
        capturedJson = json;
        return 'ok';
      },
    );

    final capturedOptions =
        verify(
              () => dio.get<dynamic>(
                '/test',
                queryParameters: <String, dynamic>{'q': '1'},
                options: captureAny(named: 'options'),
              ),
            ).captured.single
            as Options?;

    expect(result, 'ok');
    expect(capturedJson, <String, dynamic>{'id': 1});
    expect(capturedOptions?.headers, <String, String>{'x-token': 'abc'});
  });

  test('get uses empty map when response data is not a map', () async {
    final response = buildResponse(
      path: '/test',
      statusCode: 200,
      data: <dynamic>['unexpected'],
    );

    when(
      () => dio.get<dynamic>(
        '/test',
        queryParameters: any(named: 'queryParameters'),
        options: any(named: 'options'),
      ),
    ).thenAnswer((_) async => response);

    Map<String, dynamic>? capturedJson;

    await provider.get<String>(
      '/test',
      decoder: (json) {
        capturedJson = json;
        return 'ok';
      },
    );

    expect(capturedJson, <String, dynamic>{});
  });

  test('get throws HttpException on non-success status', () async {
    final response = buildResponse(
      path: '/test',
      statusCode: 500,
      data: <String, dynamic>{'error': true},
    );

    when(
      () => dio.get<dynamic>(
        '/test',
        queryParameters: any(named: 'queryParameters'),
        options: any(named: 'options'),
      ),
    ).thenAnswer((_) async => response);

    await expectLater(
      () => provider.get<String>(
        '/test',
        decoder: (_) => 'ok',
      ),
      throwsA(
        isA<HttpException>()
            .having((exception) => exception.statusCode, 'statusCode', 500)
            .having((exception) => exception.path, 'path', '/test'),
      ),
    );
  });

  test('post throws HttpException on non-success status', () async {
    final errorResponse = buildResponse(
      path: '/test',
      statusCode: 500,
    );

    when(
      () => dio.post<dynamic>(
        '/test',
        data: any(named: 'data'),
        options: any(named: 'options'),
      ),
    ).thenAnswer((_) async => errorResponse);

    await expectLater(
      () => provider.post('/test', body: <String, dynamic>{'a': 1}),
      throwsA(isA<HttpException>()),
    );
  });

  test('put throws HttpException on non-success status', () async {
    final errorResponse = buildResponse(
      path: '/test',
      statusCode: 500,
    );

    when(
      () => dio.put<dynamic>(
        '/test',
        data: any(named: 'data'),
        options: any(named: 'options'),
      ),
    ).thenAnswer((_) async => errorResponse);

    await expectLater(
      () => provider.put('/test', body: <String, dynamic>{'a': 1}),
      throwsA(isA<HttpException>()),
    );
  });

  test('patch throws HttpException on non-success status', () async {
    final errorResponse = buildResponse(
      path: '/test',
      statusCode: 500,
    );

    when(
      () => dio.patch<dynamic>(
        '/test',
        data: any(named: 'data'),
        options: any(named: 'options'),
      ),
    ).thenAnswer((_) async => errorResponse);

    await expectLater(
      () => provider.patch('/test', body: <String, dynamic>{'a': 1}),
      throwsA(isA<HttpException>()),
    );
  });

  test('delete throws HttpException on non-success status', () async {
    final errorResponse = buildResponse(
      path: '/test',
      statusCode: 500,
    );

    when(
      () => dio.delete<dynamic>(
        '/test',
        options: any(named: 'options'),
      ),
    ).thenAnswer((_) async => errorResponse);

    await expectLater(
      () => provider.delete('/test'),
      throwsA(isA<HttpException>()),
    );
  });
}
