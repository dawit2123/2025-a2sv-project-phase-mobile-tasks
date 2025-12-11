import '../models/product_model.dart';

abstract class ProductLocalDataSource {
  Future<ProductModel> getProduct(String id);
  Future<void> insertProduct(ProductModel product);
  Future<void> updateProduct(ProductModel product);
  Future<void> deleteProduct(String id);
}
