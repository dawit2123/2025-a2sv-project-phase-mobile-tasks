class Product {
  final String id;
  final String name;
  final String category;
  final double price;
  final String imageUrl;
  final double rating;
  final String description;
  final List<int> sizes;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.imageUrl,
    this.rating = 0.0, // Default for new products
    this.description = 'No description provided.', // Default
    this.sizes = const [39, 40, 41, 42], // Default
  });
}