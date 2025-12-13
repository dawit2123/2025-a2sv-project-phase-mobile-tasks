import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:task7/core/error/failures.dart';
import 'package:task7/features/product/domain/entities/product.dart';
import 'package:task7/features/product/domain/usecases/delete_product.dart';
import 'package:task7/features/product/domain/usecases/get_product.dart';
import 'package:task7/features/product/domain/usecases/insert_product.dart';
import 'package:task7/features/product/domain/usecases/update_product.dart';
import 'package:task7/features/product/presentation/bloc/product_bloc.dart';
import 'package:task7/features/product/presentation/bloc/product_event.dart';
import 'package:task7/features/product/presentation/bloc/product_state.dart';

@GenerateMocks([
  GetProduct,
  InsertProduct,
  UpdateProduct,
  DeleteProduct,
])
import 'product_bloc_test.mocks.dart';

void main() {
  late MockGetProduct mockGetProduct;
  late MockInsertProduct mockInsertProduct;
  late MockUpdateProduct mockUpdateProduct;
  late MockDeleteProduct mockDeleteProduct;
  late ProductBloc productBloc;

  setUp(() {
    mockGetProduct = MockGetProduct();
    mockInsertProduct = MockInsertProduct();
    mockUpdateProduct = MockUpdateProduct();
    mockDeleteProduct = MockDeleteProduct();
    productBloc = ProductBloc(
      getProduct: mockGetProduct,
      insertProduct: mockInsertProduct,
      updateProduct: mockUpdateProduct,
      deleteProduct: mockDeleteProduct,
    );
  });

  tearDown(() {
    productBloc.close();
  });

  const tProduct = Product(
    id: '1',
    name: 'Test Product',
    description: 'Test Description',
    price: 99.99,
    imageUrl: 'https://example.com/image.jpg',
  );

  group('ProductBloc', () {
    test('initial state should be ProductInitial', () {
      expect(productBloc.state, equals(const ProductInitial()));
    });

    group('LoadProductEvent', () {
      blocTest<ProductBloc, ProductState>(
        'should emit [ProductLoading, ProductLoaded] when data is gotten successfully',
        build: () {
          when(mockGetProduct(any))
              .thenAnswer((_) async => const Right(tProduct));
          return productBloc;
        },
        act: (bloc) => bloc.add(const LoadProductEvent('1')),
        expect: () => [
          const ProductLoading(),
          const ProductLoaded(tProduct),
        ],
        verify: (_) {
          verify(mockGetProduct('1'));
        },
      );

      blocTest<ProductBloc, ProductState>(
        'should emit [ProductLoading, ProductError] when getting data fails with ServerFailure',
        build: () {
          when(mockGetProduct(any))
              .thenAnswer((_) async => Left(ServerFailure()));
          return productBloc;
        },
        act: (bloc) => bloc.add(const LoadProductEvent('1')),
        expect: () => [
          const ProductLoading(),
          const ProductError('Server failure - please try again later'),
        ],
        verify: (_) {
          verify(mockGetProduct('1'));
        },
      );

      blocTest<ProductBloc, ProductState>(
        'should emit [ProductLoading, ProductError] when getting data fails with CacheFailure',
        build: () {
          when(mockGetProduct(any))
              .thenAnswer((_) async => Left(CacheFailure()));
          return productBloc;
        },
        act: (bloc) => bloc.add(const LoadProductEvent('1')),
        expect: () => [
          const ProductLoading(),
          const ProductError('Cache failure - no local data available'),
        ],
        verify: (_) {
          verify(mockGetProduct('1'));
        },
      );

      blocTest<ProductBloc, ProductState>(
        'should emit [ProductLoading, ProductError] when getting data fails with NetworkFailure',
        build: () {
          when(mockGetProduct(any))
              .thenAnswer((_) async => Left(NetworkFailure()));
          return productBloc;
        },
        act: (bloc) => bloc.add(const LoadProductEvent('1')),
        expect: () => [
          const ProductLoading(),
          const ProductError('Network failure - please check your internet connection'),
        ],
        verify: (_) {
          verify(mockGetProduct('1'));
        },
      );
    });

    group('CreateProductEvent', () {
      blocTest<ProductBloc, ProductState>(
        'should emit [ProductLoading, ProductOperationSuccess] when product is created successfully',
        build: () {
          when(mockInsertProduct(any))
              .thenAnswer((_) async => const Right(null));
          return productBloc;
        },
        act: (bloc) => bloc.add(const CreateProductEvent(tProduct)),
        expect: () => [
          const ProductLoading(),
          const ProductOperationSuccess('Product created successfully'),
        ],
        verify: (_) {
          verify(mockInsertProduct(tProduct));
        },
      );

      blocTest<ProductBloc, ProductState>(
        'should emit [ProductLoading, ProductError] when product creation fails',
        build: () {
          when(mockInsertProduct(any))
              .thenAnswer((_) async => Left(ServerFailure()));
          return productBloc;
        },
        act: (bloc) => bloc.add(const CreateProductEvent(tProduct)),
        expect: () => [
          const ProductLoading(),
          const ProductError('Server failure - please try again later'),
        ],
        verify: (_) {
          verify(mockInsertProduct(tProduct));
        },
      );
    });

    group('UpdateProductEvent', () {
      blocTest<ProductBloc, ProductState>(
        'should emit [ProductLoading, ProductOperationSuccess] when product is updated successfully',
        build: () {
          when(mockUpdateProduct(any))
              .thenAnswer((_) async => const Right(null));
          return productBloc;
        },
        act: (bloc) => bloc.add(const UpdateProductEvent(tProduct)),
        expect: () => [
          const ProductLoading(),
          const ProductOperationSuccess('Product updated successfully'),
        ],
        verify: (_) {
          verify(mockUpdateProduct(tProduct));
        },
      );

      blocTest<ProductBloc, ProductState>(
        'should emit [ProductLoading, ProductError] when product update fails',
        build: () {
          when(mockUpdateProduct(any))
              .thenAnswer((_) async => Left(NetworkFailure()));
          return productBloc;
        },
        act: (bloc) => bloc.add(const UpdateProductEvent(tProduct)),
        expect: () => [
          const ProductLoading(),
          const ProductError('Network failure - please check your internet connection'),
        ],
        verify: (_) {
          verify(mockUpdateProduct(tProduct));
        },
      );
    });

    group('DeleteProductEvent', () {
      blocTest<ProductBloc, ProductState>(
        'should emit [ProductLoading, ProductOperationSuccess] when product is deleted successfully',
        build: () {
          when(mockDeleteProduct(any))
              .thenAnswer((_) async => const Right(null));
          return productBloc;
        },
        act: (bloc) => bloc.add(const DeleteProductEvent('1')),
        expect: () => [
          const ProductLoading(),
          const ProductOperationSuccess('Product deleted successfully'),
        ],
        verify: (_) {
          verify(mockDeleteProduct('1'));
        },
      );

      blocTest<ProductBloc, ProductState>(
        'should emit [ProductLoading, ProductError] when product deletion fails',
        build: () {
          when(mockDeleteProduct(any))
              .thenAnswer((_) async => Left(CacheFailure()));
          return productBloc;
        },
        act: (bloc) => bloc.add(const DeleteProductEvent('1')),
        expect: () => [
          const ProductLoading(),
          const ProductError('Cache failure - no local data available'),
        ],
        verify: (_) {
          verify(mockDeleteProduct('1'));
        },
      );
    });
  });
}
