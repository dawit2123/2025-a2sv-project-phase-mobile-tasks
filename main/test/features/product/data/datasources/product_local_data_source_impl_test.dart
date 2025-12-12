import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task7/features/product/data/datasources/product_local_data_source_impl.dart'
    show ProductLocalDataSourceImpl, cachedProductsKey;
import 'package:task7/features/product/data/models/product_model.dart';

@GenerateMocks([SharedPreferences])
import 'product_local_data_source_impl_test.mocks.dart';

void main() {
  late MockSharedPreferences mockSharedPreferences;
  late ProductLocalDataSourceImpl dataSource;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = ProductLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });

  group('ProductLocalDataSourceImpl', () {
    const tProductModel = ProductModel(
      id: '1',
      name: 'Test Product',
      description: 'Test Description',
      price: 99.99,
      imageUrl: 'https://example.com/image.jpg',
    );

    group('getProduct', () {
      test('should return ProductModel from SharedPreferences when present', () async {
        // arrange
        final jsonString = json.encode(tProductModel.toJson());
        when(mockSharedPreferences.getString('$cachedProductsKey:1'))
            .thenReturn(jsonString);

        // act
        final result = await dataSource.getProduct('1');

        // assert
        verify(mockSharedPreferences.getString('$cachedProductsKey:1'));
        expect(result, tProductModel);
      });

      test('should throw an exception when product is not found', () async {
        // arrange
        when(mockSharedPreferences.getString('$cachedProductsKey:1'))
            .thenReturn(null);

        // act
        final call = dataSource.getProduct('1');

        // assert
        expect(() => call, throwsException);
      });
    });

    group('insertProduct', () {
      test('should call SharedPreferences to cache the product', () async {
        // arrange
        final jsonString = json.encode(tProductModel.toJson());
        when(mockSharedPreferences.setString(any, any))
            .thenAnswer((_) async => true);
        when(mockSharedPreferences.getString('${cachedProductsKey}_IDS'))
            .thenReturn(null);

        // act
        await dataSource.insertProduct(tProductModel);

        // assert
        verify(mockSharedPreferences.setString(
          '$cachedProductsKey:${tProductModel.id}',
          jsonString,
        ));
      });

      test('should update product IDs list when inserting new product', () async {
        // arrange
        when(mockSharedPreferences.setString(any, any))
            .thenAnswer((_) async => true);
        when(mockSharedPreferences.getString('${cachedProductsKey}_IDS'))
            .thenReturn(json.encode(['2', '3']));

        // act
        await dataSource.insertProduct(tProductModel);

        // assert
        verify(mockSharedPreferences.setString(
          '${cachedProductsKey}_IDS',
          json.encode(['2', '3', '1']),
        ));
      });
    });

    group('updateProduct', () {
      test('should call SharedPreferences to update the product', () async {
        // arrange
        final jsonString = json.encode(tProductModel.toJson());
        when(mockSharedPreferences.setString(any, any))
            .thenAnswer((_) async => true);

        // act
        await dataSource.updateProduct(tProductModel);

        // assert
        verify(mockSharedPreferences.setString(
          '$cachedProductsKey:${tProductModel.id}',
          jsonString,
        ));
      });
    });

    group('deleteProduct', () {
      test('should call SharedPreferences to remove the product', () async {
        // arrange
        when(mockSharedPreferences.remove(any)).thenAnswer((_) async => true);
        when(mockSharedPreferences.getString('${cachedProductsKey}_IDS'))
            .thenReturn(json.encode(['1', '2', '3']));
        when(mockSharedPreferences.setString(any, any))
            .thenAnswer((_) async => true);

        // act
        await dataSource.deleteProduct('1');

        // assert
        verify(mockSharedPreferences.remove('$cachedProductsKey:1'));
        verify(mockSharedPreferences.setString(
          '${cachedProductsKey}_IDS',
          json.encode(['2', '3']),
        ));
      });
    });
  });
}
