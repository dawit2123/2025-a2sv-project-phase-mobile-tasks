import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_local_data_source.dart';
import '../datasources/product_remote_data_source.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  ProductModel _toModel(Product product) {
    return ProductModel(
      id: product.id,
      name: product.name,
      description: product.description,
      price: product.price,
      imageUrl: product.imageUrl,
    );
  }

  @override
  Future<Either<Failure, Product>> getProduct(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteProduct = await remoteDataSource.getProduct(id);
        await localDataSource.insertProduct(remoteProduct);
        return Right(remoteProduct);
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
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
    return await _performNetworkOperation(
      () async {
        final productModel = _toModel(product);
        await remoteDataSource.insertProduct(productModel);
        await localDataSource.insertProduct(productModel);
      },
    );
  }

  @override
  Future<Either<Failure, void>> updateProduct(Product product) async {
    return await _performNetworkOperation(
      () async {
        final productModel = _toModel(product);
        await remoteDataSource.updateProduct(productModel);
        await localDataSource.updateProduct(productModel);
      },
    );
  }

  @override
  Future<Either<Failure, void>> deleteProduct(String id) async {
    return await _performNetworkOperation(
      () async {
        await remoteDataSource.deleteProduct(id);
        await localDataSource.deleteProduct(id);
      },
    );
  }

  Future<Either<Failure, void>> _performNetworkOperation(
    Future<void> Function() operation,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        await operation();
        return const Right(null);
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
