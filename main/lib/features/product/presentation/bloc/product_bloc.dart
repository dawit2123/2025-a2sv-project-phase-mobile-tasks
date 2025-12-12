import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../domain/usecases/delete_product.dart';
import '../../domain/usecases/get_product.dart';
import '../../domain/usecases/insert_product.dart';
import '../../domain/usecases/update_product.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProduct getProduct;
  final InsertProduct insertProduct;
  final UpdateProduct updateProduct;
  final DeleteProduct deleteProduct;

  ProductBloc({
    required this.getProduct,
    required this.insertProduct,
    required this.updateProduct,
    required this.deleteProduct,
  }) : super(const ProductInitial()) {
    on<LoadProductEvent>(_onLoadProduct);
    on<CreateProductEvent>(_onCreateProduct);
    on<UpdateProductEvent>(_onUpdateProduct);
    on<DeleteProductEvent>(_onDeleteProduct);
  }

  Future<void> _onLoadProduct(
    LoadProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(const ProductLoading());
    final result = await getProduct(event.id);
    result.fold(
      (failure) => emit(ProductError(_mapFailureToMessage(failure))),
      (product) => emit(ProductLoaded(product)),
    );
  }

  Future<void> _onCreateProduct(
    CreateProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(const ProductLoading());
    final result = await insertProduct(event.product);
    result.fold(
      (failure) => emit(ProductError(_mapFailureToMessage(failure))),
      (_) => emit(const ProductOperationSuccess('Product created successfully')),
    );
  }

  Future<void> _onUpdateProduct(
    UpdateProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(const ProductLoading());
    final result = await updateProduct(event.product);
    result.fold(
      (failure) => emit(ProductError(_mapFailureToMessage(failure))),
      (_) => emit(const ProductOperationSuccess('Product updated successfully')),
    );
  }

  Future<void> _onDeleteProduct(
    DeleteProductEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(const ProductLoading());
    final result = await deleteProduct(event.id);
    result.fold(
      (failure) => emit(ProductError(_mapFailureToMessage(failure))),
      (_) => emit(const ProductOperationSuccess('Product deleted successfully')),
    );
  }

  String _mapFailureToMessage(dynamic failure) {
    switch (failure.runtimeType) {
      case const (ServerFailure):
        return 'Server failure - please try again later';
      case const (CacheFailure):
        return 'Cache failure - no local data available';
      case const (NetworkFailure):
        return 'Network failure - please check your internet connection';
      default:
        return 'Unexpected error occurred';
    }
  }
}
