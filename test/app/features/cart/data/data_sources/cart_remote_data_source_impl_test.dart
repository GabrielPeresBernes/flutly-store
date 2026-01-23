import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutly_store/app/features/cart/data/data_sources/cart_remote_data_source_impl.dart';
import 'package:flutly_store/app/features/cart/data/models/cart_model.dart';
import 'package:flutly_store/app/features/cart/data/models/cart_product_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockCollectionReference extends Mock
    implements CollectionReference<Map<String, dynamic>> {}

class MockDocumentReference extends Mock
    implements DocumentReference<Map<String, dynamic>> {}

class MockDocumentSnapshot extends Mock
    implements DocumentSnapshot<Map<String, dynamic>> {}

void main() {
  late FirebaseFirestore firestore;
  late CollectionReference<Map<String, dynamic>> collection;
  late DocumentReference<Map<String, dynamic>> docRef;
  late CartRemoteDataSourceImpl dataSource;

  const userId = 'user-1';
  final cart = CartModel(
    totalPrice: 120.0,
    totalItems: 2,
    products: {
      1: CartProductModel(
        id: 1,
        quantity: 2,
        thumbnail: 'thumb.png',
        name: 'Item',
        price: 60.0,
      ),
    },
  );

  setUp(() {
    firestore = MockFirebaseFirestore();
    collection = MockCollectionReference();
    docRef = MockDocumentReference();
    dataSource = CartRemoteDataSourceImpl(firestore);

    when(() => firestore.collection('carts')).thenReturn(collection);
    when(() => collection.doc(userId)).thenReturn(docRef);
  });

  test('saveCart stores cart json in remote storage', () async {
    final cartJson = jsonEncode(cart.toJson());
    when(() => docRef.set({'cart': cartJson})).thenAnswer((_) async {});

    final result = await dataSource.saveCart(userId, cart).run();

    expect(result.isRight(), isTrue);
    verify(() => docRef.set({'cart': cartJson})).called(1);
  });

  test('getCart returns Some when cart data exists', () async {
    final cartJson = jsonEncode(cart.toJson());
    final snapshot = MockDocumentSnapshot();
    when(() => docRef.get()).thenAnswer((_) async => snapshot);
    when(() => snapshot.exists).thenReturn(true);
    when(snapshot.data).thenReturn({'cart': cartJson});

    final result = await dataSource.getCart(userId).run();

    expect(result.isRight(), isTrue);
    result.match(
      (_) => fail('Expected cart'),
      (value) {
        final loaded = value.toNullable();
        expect(loaded, isNotNull);
        expect(loaded!.totalItems, cart.totalItems);
        expect(loaded.totalPrice, cart.totalPrice);
        expect(loaded.products[1]?.quantity, cart.products[1]?.quantity);
        expect(loaded.products[1]?.name, cart.products[1]?.name);
      },
    );
  });

  test('getCart returns None when document does not exist', () async {
    final snapshot = MockDocumentSnapshot();
    when(() => docRef.get()).thenAnswer((_) async => snapshot);
    when(() => snapshot.exists).thenReturn(false);

    final result = await dataSource.getCart(userId).run();

    expect(result.isRight(), isTrue);
    result.match(
      (_) => fail('Expected none'),
      (value) => expect(value.isNone(), isTrue),
    );
  });

  test('getCart returns None when cart field is missing', () async {
    final snapshot = MockDocumentSnapshot();
    when(() => docRef.get()).thenAnswer((_) async => snapshot);
    when(() => snapshot.exists).thenReturn(true);
    when(snapshot.data).thenReturn({});

    final result = await dataSource.getCart(userId).run();

    expect(result.isRight(), isTrue);
    result.match(
      (_) => fail('Expected none'),
      (value) => expect(value.isNone(), isTrue),
    );
  });

  test('clearCart deletes remote cart document', () async {
    when(() => docRef.delete()).thenAnswer((_) async {});

    final result = await dataSource.clearCart(userId).run();

    expect(result.isRight(), isTrue);
    verify(() => docRef.delete()).called(1);
  });
}
