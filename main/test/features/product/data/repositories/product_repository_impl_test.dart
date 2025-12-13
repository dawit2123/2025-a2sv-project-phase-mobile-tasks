import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:task7/core/error/failures.dart';
import 'package:task7/core/network/network_info.dart';
import 'package:task7/features/product/data/datasources/product_local_data_source.dart';
import 'package:task7/features/product/data/datasources/product_remote_data_source.dart';
import 'package:task7/features/product/data/models/product_model.dart';
import 'package:task7/features/product/data/repositories/product_repository_impl.dart';
import 'package:task7/features/product/domain/entities/product.dart';

@GenerateMocks([
  ProductRemoteDataSource,
  ProductLocalDataSource,
  NetworkInfo,
])
import 'product_repository_impl_test.mocks.dart';

void main() {
  late MockProductRemoteDataSource mockRemoteDataSource;
  late MockProductLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;
  late ProductRepositoryImpl repository;

  setUp(() {
    mockRemoteDataSource = MockProductRemoteDataSource();
    mockLocalDataSource = MockProductLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = ProductRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('ProductRepositoryImpl', () {
    const tProductModel = ProductModel(
      id: '1',
      name: 'Test Product',
      description: 'Test Description',
      price: 99.99,
      imageUrl: 'https://example.com/image.jpg',
    );

    const Product tProduct = tProductModel;

    group('getProduct', () {
      test('should check if the device is online', () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(mockRemoteDataSource.getProduct(any))
            .thenAnswer((_) async => tProductModel);
        when(mockLocalDataSource.insertProduct(any))
            .thenAnswer((_) async => null);

        // act
        await repository.getProduct('1');

        // assert
        verify(mockNetworkInfo.isConnected);
      });

      group('device is online', () {
        setUp(() {
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        });

        test('should return remote data when the call to remote data source is successful', () async {
          // arrange
          when(mockRemoteDataSource.getProduct(any))
              .thenAnswer((_) async => tProductModel);
          when(mockLocalDataSource.insertProduct(any))
              .thenAnswer((_) async => null);

          // act
          final result = await repository.getProduct('1');

          // assert
          verify(mockRemoteDataSource.getProduct('1'));
          expect(result, equals(const Right(tProduct)));
        });

        test('should cache the data locally when the call to remote data source is successful', () async {
          // arrange
          when(mockRemoteDataSource.getProduct(any))
              .thenAnswer((_) async => tProductModel);
          when(mockLocalDataSource.insertProduct(any))
              .thenAnswer((_) async => null);

          // act
          await repository.getProduct('1');

          // assert
          verify(mockRemoteDataSource.getProduct('1'));
          verify(mockLocalDataSource.insertProduct(tProductModel));
        });

        test('should return server failure when the call to remote data source is unsuccessful', () async {
          // arrange
          when(mockRemoteDataSource.getProduct(any))
              .thenThrow(Exception('Server error'));

          // act
          final result = await repository.getProduct('1');

          // assert
          verify(mockRemoteDataSource.getProduct('1'));
          expect(result, equals(Left(ServerFailure())));
        });
      });

      group('device is offline', () {
        setUp(() {
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        });

        test('should return local data when the cached data is present', () async {
          // arrange
          when(mockLocalDataSource.getProduct(any))
              .thenAnswer((_) async => tProductModel);

          // act
          final result = await repository.getProduct('1');

          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getProduct('1'));
          expect(result, equals(const Right(tProduct)));
        });

        test('should return cache failure when there is no cached data', () async {
          // arrange
          when(mockLocalDataSource.getProduct(any))
              .thenThrow(Exception('No cache'));

          // act
          final result = await repository.getProduct('1');

          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getProduct('1'));
          expect(result, equals(Left(CacheFailure())));
        });
      });
    });

    group('insertProduct', () {
      test('should check if the device is online', () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(mockRemoteDataSource.insertProduct(any))
            .thenAnswer((_) async => null);
        when(mockLocalDataSource.insertProduct(any))
            .thenAnswer((_) async => null);

        // act
        await repository.insertProduct(tProduct);

        // assert
        verify(mockNetworkInfo.isConnected);
      });

      group('device is online', () {
        setUp(() {
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        });

        test('should insert product remotely and cache it locally when successful', () async {
          // arrange
          when(mockRemoteDataSource.insertProduct(any))
              .thenAnswer((_) async => null);
          when(mockLocalDataSource.insertProduct(any))
              .thenAnswer((_) async => null);

          // act
          final result = await repository.insertProduct(tProduct);

          // assert
          verify(mockRemoteDataSource.insertProduct(tProductModel));
          verify(mockLocalDataSource.insertProduct(tProductModel));
          expect(result, equals(const Right(null)));
        });

        test('should return server failure when remote insertion fails', () async {
          // arrange
          when(mockRemoteDataSource.insertProduct(any))
              .thenThrow(Exception('Server error'));

          // act
          final result = await repository.insertProduct(tProduct);

          // assert
          expect(result, equals(Left(ServerFailure())));
        });
      });

      group('device is offline', () {
        setUp(() {
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        });

        test('should return network failure when device is offline', () async {
          // act
          final result = await repository.insertProduct(tProduct);

          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(NetworkFailure())));
        });
      });
    });

    group('updateProduct', () {
      test('should check if the device is online', () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(mockRemoteDataSource.updateProduct(any))
            .thenAnswer((_) async => null);
        when(mockLocalDataSource.updateProduct(any))
            .thenAnswer((_) async => null);

        // act
        await repository.updateProduct(tProduct);

        // assert
        verify(mockNetworkInfo.isConnected);
      });

      group('device is online', () {
        setUp(() {
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        });

        test('should update product remotely and cache it locally when successful', () async {
          // arrange
          when(mockRemoteDataSource.updateProduct(any))
              .thenAnswer((_) async => null);
          when(mockLocalDataSource.updateProduct(any))
              .thenAnswer((_) async => null);

          // act
          final result = await repository.updateProduct(tProduct);

          // assert
          verify(mockRemoteDataSource.updateProduct(tProductModel));
          verify(mockLocalDataSource.updateProduct(tProductModel));
          expect(result, equals(const Right(null)));
        });

        test('should return server failure when remote update fails', () async {
          // arrange
          when(mockRemoteDataSource.updateProduct(any))
              .thenThrow(Exception('Server error'));

          // act
          final result = await repository.updateProduct(tProduct);

          // assert
          expect(result, equals(Left(ServerFailure())));
        });
      });

      group('device is offline', () {
        setUp(() {
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        });

        test('should return network failure when device is offline', () async {
          // act
          final result = await repository.updateProduct(tProduct);

          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(NetworkFailure())));
        });
      });
    });

    group('deleteProduct', () {
      test('should check if the device is online', () async {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(mockRemoteDataSource.deleteProduct(any))
            .thenAnswer((_) async => null);
        when(mockLocalDataSource.deleteProduct(any))
            .thenAnswer((_) async => null);

        // act
        await repository.deleteProduct('1');

        // assert
        verify(mockNetworkInfo.isConnected);
      });

      group('device is online', () {
        setUp(() {
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        });

        test('should delete product remotely and from cache when successful', () async {
          // arrange
          when(mockRemoteDataSource.deleteProduct(any))
              .thenAnswer((_) async => null);
          when(mockLocalDataSource.deleteProduct(any))
              .thenAnswer((_) async => null);

          // act
          final result = await repository.deleteProduct('1');

          // assert
          verify(mockRemoteDataSource.deleteProduct('1'));
          verify(mockLocalDataSource.deleteProduct('1'));
          expect(result, equals(const Right(null)));
        });

        test('should return server failure when remote deletion fails', () async {
          // arrange
          when(mockRemoteDataSource.deleteProduct(any))
              .thenThrow(Exception('Server error'));

          // act
          final result = await repository.deleteProduct('1');

          // assert
          expect(result, equals(Left(ServerFailure())));
        });
      });

      group('device is offline', () {
        setUp(() {
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        });

        test('should return network failure when device is offline', () async {
          // act
          final result = await repository.deleteProduct('1');

          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verifyZeroInteractions(mockLocalDataSource);
          expect(result, equals(Left(NetworkFailure())));
        });
      });
    });
  });
}
