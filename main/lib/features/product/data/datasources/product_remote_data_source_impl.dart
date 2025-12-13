import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/product_model.dart';
import 'product_remote_data_source.dart';

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  ProductRemoteDataSourceImpl({
    required this.client,
    this.baseUrl = 'https://g5-flutter-learning-path-be.onrender.com/api/v1',
  });

  @override
  Future<ProductModel> getProduct(String id) async {
    final response = await client.get(
      Uri.parse('$baseUrl/products/$id'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return ProductModel.fromJson(jsonData['data']);
    } else {
      throw Exception('Failed to fetch product: ${response.statusCode}');
    }
  }

  @override
  Future<void> insertProduct(ProductModel product) async {
    final response = await client.post(
      Uri.parse('$baseUrl/products'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(product.toJson()),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Failed to insert product: ${response.statusCode}');
    }
  }

  @override
  Future<void> updateProduct(ProductModel product) async {
    final response = await client.put(
      Uri.parse('$baseUrl/products/${product.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(product.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update product: ${response.statusCode}');
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    final response = await client.delete(
      Uri.parse('$baseUrl/products/$id'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete product: ${response.statusCode}');
    }
  }
}
