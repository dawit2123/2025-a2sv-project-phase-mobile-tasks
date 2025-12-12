import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/product_model.dart';
import 'product_local_data_source.dart';

const cachedProductsKey = 'CACHED_PRODUCTS';

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final SharedPreferences sharedPreferences;

  ProductLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<ProductModel> getProduct(String id) async {
    final jsonString = sharedPreferences.getString('$cachedProductsKey:$id');
    if (jsonString != null) {
      return ProductModel.fromJson(json.decode(jsonString));
    } else {
      throw Exception('Product not found in cache');
    }
  }

  @override
  Future<void> insertProduct(ProductModel product) async {
    final jsonString = json.encode(product.toJson());
    await sharedPreferences.setString(
      '$cachedProductsKey:${product.id}',
      jsonString,
    );
    
    // Also maintain a list of all product IDs
    final productIds = await _getProductIds();
    if (!productIds.contains(product.id)) {
      productIds.add(product.id);
      await _saveProductIds(productIds);
    }
  }

  @override
  Future<void> updateProduct(ProductModel product) async {
    // Update works the same as insert for shared preferences
    final jsonString = json.encode(product.toJson());
    await sharedPreferences.setString(
      '$cachedProductsKey:${product.id}',
      jsonString,
    );
  }

  @override
  Future<void> deleteProduct(String id) async {
    await sharedPreferences.remove('$cachedProductsKey:$id');
    
    // Remove from product IDs list
    final productIds = await _getProductIds();
    productIds.remove(id);
    await _saveProductIds(productIds);
  }

  Future<List<String>> _getProductIds() async {
    final jsonString = sharedPreferences.getString('${cachedProductsKey}_IDS');
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.cast<String>();
    }
    return [];
  }

  Future<void> _saveProductIds(List<String> ids) async {
    final jsonString = json.encode(ids);
    await sharedPreferences.setString('${cachedProductsKey}_IDS', jsonString);
  }
}
