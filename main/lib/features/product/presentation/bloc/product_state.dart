import 'package:equatable/equatable.dart';

import '../../domain/entities/product.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

class ProductInitial extends ProductState {
  const ProductInitial();
}

class ProductLoading extends ProductState {
  const ProductLoading();
}

class ProductLoaded extends ProductState {
  final Product product;

  const ProductLoaded(this.product);

  @override
  List<Object> get props => [product];
}

class ProductsLoaded extends ProductState {
  final List<Product> products;

  const ProductsLoaded(this.products);

  @override
  List<Object> get props => [products];
}

class ProductOperationSuccess extends ProductState {
  final String message;

  const ProductOperationSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class ProductError extends ProductState {
  final String message;

  const ProductError(this.message);

  @override
  List<Object> get props => [message];
}
