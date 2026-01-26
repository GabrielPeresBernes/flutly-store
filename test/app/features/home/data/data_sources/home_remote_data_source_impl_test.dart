import 'package:flutly_store/app/core/http/http.dart';
import 'package:flutly_store/app/features/home/home.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCoreHttp extends Mock implements CoreHttp {}

void main() {
  late CoreHttp http;
  late HomeRemoteDataSourceImpl dataSource;

  const homeProductList = HomeProductListModel(
    title: 'Featured',
    variant: 'grid',
    products: [
      HomeProductModel(
        id: '1',
        title: 'Phone',
        price: 199.0,
        image: 'phone.png',
      ),
    ],
  );

  setUp(() {
    http = MockCoreHttp();
    dataSource = HomeRemoteDataSourceImpl(http);
  });

  test('getProducts decodes sections and forwards query', () async {
    when(
      () => http.get<List<HomeProductListModel>>(
        any(),
        queryParameters: any(named: 'queryParameters'),
        decoder: any(named: 'decoder'),
      ),
    ).thenAnswer((_) async => [homeProductList]);

    final result = await dataSource.getProducts().run();

    expect(result.isRight(), isTrue);
    result.match(
      (_) => fail('Expected products'),
      (value) {
        expect(value.length, 1);
        expect(value.first.title, 'Featured');
        expect(value.first.products.length, 1);
        expect(value.first.products.first.title, 'Phone');
      },
    );

    final captured = verify(
      () => http.get<List<HomeProductListModel>>(
        captureAny(),
        queryParameters: captureAny(named: 'queryParameters'),
        decoder: any(named: 'decoder'),
      ),
    ).captured;
    final query = captured[1] as Map<String, dynamic>;

    expect(query['query'], isNotNull);
  });
}
