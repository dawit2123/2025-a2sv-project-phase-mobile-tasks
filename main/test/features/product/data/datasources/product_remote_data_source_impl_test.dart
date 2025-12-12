import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:task7/features/product/data/datasources/product_remote_data_source_impl.dart';
import 'package:task7/features/product/data/models/product_model.dart';

@GenerateMocks([http.Client])
import 'product_remote_data_source_impl_test.mocks.dart';

void main() {
  late MockClient mockClient;
  late ProductRemoteDataSourceImpl dataSource;
  const baseUrl = 'https://g5-flutter-learning-path-be.onrender.com/api/v1';

  setUp(() {
    mockClient = MockClient();
    dataSource = ProductRemoteDataSourceImpl(client: mockClient);
  });

  group('ProductRemoteDataSourceImpl', () {
    const tProductModel = ProductModel(
      id: '1',
      name: 'Test Product',
      description: 'Test Description',
      price: 99.99,
      imageUrl: 'https://example.com/image.jpg',
    );

    group('getProduct', () {
      test('should perform a GET request on a URL with product id', () async {
        // arrange
        when(mockClient.get(
          Uri.parse('$baseUrl/products/1'),
          headers: anyNamed('headers'),
        )).thenAnswer((_) async => http.Response(
              json.encode({'data': tProductModel.toJson()}),
              200,
            ));

        // act
        await dataSource.getProduct('1');

        // assert
        verify(mockClient.get(
          Uri.parse('$baseUrl/products/1'),
          headers: {'Content-Type': 'application/json'},
        ));
      });

      test('should return ProductModel when the response code is 200', () async {
        // arrange
        when(mockClient.get(
          Uri.parse('$baseUrl/products/1'),
          headers: anyNamed('headers'),
        )).thenAnswer((_) async => http.Response(
              json.encode({'data': tProductModel.toJson()}),
              200,
            ));

        // act
        final result = await dataSource.getProduct('1');

        // assert
        expect(result, tProductModel);
      });

      test('should throw an exception when the response code is not 200', () async {
        // arrange
        when(mockClient.get(
          Uri.parse('$baseUrl/products/1'),
          headers: anyNamed('headers'),
        )).thenAnswer((_) async => http.Response('Not found', 404));

        // act
        final call = dataSource.getProduct('1');

        // assert
        expect(() => call, throwsException);
      });
    });

    group('insertProduct', () {
      test('should perform a POST request with product data', () async {
        // arrange
        when(mockClient.post(
          Uri.parse('$baseUrl/products'),
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenAnswer((_) async => http.Response('', 201));

        // act
        await dataSource.insertProduct(tProductModel);

        // assert
        verify(mockClient.post(
          Uri.parse('$baseUrl/products'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(tProductModel.toJson()),
        ));
      });

      test('should throw an exception when the response code is not 200/201', () async {
        // arrange
        when(mockClient.post(
          Uri.parse('$baseUrl/products'),
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenAnswer((_) async => http.Response('Error', 400));

        // act
        final call = dataSource.insertProduct(tProductModel);

        // assert
        expect(() => call, throwsException);
      });
    });

    group('updateProduct', () {
      test('should perform a PUT request with product data', () async {
        // arrange
        when(mockClient.put(
          Uri.parse('$baseUrl/products/${tProductModel.id}'),
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenAnswer((_) async => http.Response('', 200));

        // act
        await dataSource.updateProduct(tProductModel);

        // assert
        verify(mockClient.put(
          Uri.parse('$baseUrl/products/${tProductModel.id}'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(tProductModel.toJson()),
        ));
      });

      test('should throw an exception when the response code is not 200', () async {
        // arrange
        when(mockClient.put(
          Uri.parse('$baseUrl/products/${tProductModel.id}'),
          headers: anyNamed('headers'),
          body: anyNamed('body'),
        )).thenAnswer((_) async => http.Response('Error', 400));

        // act
        final call = dataSource.updateProduct(tProductModel);

        // assert
        expect(() => call, throwsException);
      });
    });

    group('deleteProduct', () {
      test('should perform a DELETE request with product id', () async {
        // arrange
        when(mockClient.delete(
          Uri.parse('$baseUrl/products/1'),
          headers: anyNamed('headers'),
        )).thenAnswer((_) async => http.Response('', 200));

        // act
        await dataSource.deleteProduct('1');

        // assert
        verify(mockClient.delete(
          Uri.parse('$baseUrl/products/1'),
          headers: {'Content-Type': 'application/json'},
        ));
      });

      test('should throw an exception when the response code is not 200/204', () async {
        // arrange
        when(mockClient.delete(
          Uri.parse('$baseUrl/products/1'),
          headers: anyNamed('headers'),
        )).thenAnswer((_) async => http.Response('Error', 400));

        // act
        final call = dataSource.deleteProduct('1');

        // assert
        expect(() => call, throwsException);
      });
    });
  });
}
