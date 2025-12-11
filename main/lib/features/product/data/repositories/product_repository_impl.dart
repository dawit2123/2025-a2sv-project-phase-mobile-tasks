import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_local_data_source.dart';
import '../datasources/product_remote_data_source.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, Product>> getProduct(String id) async {
    try {
      final remoteProduct = await remoteDataSource.getProduct(id);
      return Right(remoteProduct);
    } catch (e) {
      try {
        final localProduct = await localDataSource.getProduct(id);
        return Right(localProduct);
      } catch (e) {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, void>> insertProduct(Product product) async {
    try {
      final productModel = ProductModel(
        id: product.id,
        name: product.name,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      await remoteDataSource.insertProduct(productModel);
      await localDataSource.insertProduct(productModel);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateProduct(Product product) async {
    try {
      final productModel = ProductModel(
        id: product.id,
        name: product.name,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      await remoteDataSource.updateProduct(productModel);
      await localDataSource.updateProduct(productModel);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteProduct(String id) async {
    try {
      await remoteDataSource.deleteProduct(id);
      await localDataSource.deleteProduct(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
